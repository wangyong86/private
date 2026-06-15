/*
 * bench_memcpy.c
 *
 * A small memcpy bandwidth benchmark.
 *
 * Build:
 *   gcc -O3 -march=native -Wall -Wextra bench_memcpy.c -pthread -o bench_memcpy
 *
 * Examples:
 *   ./bench_memcpy
 *   ./bench_memcpy -s 2G -r 20 -w 5
 *   ./bench_memcpy -m read -s 1G -r 20 -w 5 -t 32 -p spread
 *   taskset -c 2 ./bench_memcpy -s 1G
 *   numactl --cpunodebind=0 --membind=0 ./bench_memcpy -s 4G
 */

#define _GNU_SOURCE
#define _POSIX_C_SOURCE 200809L

#include <errno.h>
#include <inttypes.h>
#include <pthread.h>
#ifdef __linux__
#include <sched.h>
#endif
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

typedef enum bench_mode
{
    BENCH_MODE_COPY,
    BENCH_MODE_READ
} bench_mode;

typedef enum place_policy
{
    PLACE_NONE,
    PLACE_PACKED,
    PLACE_SPREAD
} place_policy;

typedef struct worker_arg
{
    bench_mode  mode;
    unsigned char *src;
    unsigned char *dst;
    size_t      offset;
    size_t      length;
    uint64_t    loops;
    uint64_t    warmups;
    uint64_t   *checksums;
    pthread_barrier_t *start_barrier;
    pthread_barrier_t *end_barrier;
    int         worker_id;
    int         cpu_id;
} worker_arg;

typedef struct init_arg
{
    unsigned char *src;
    unsigned char *dst;
    size_t      offset;
    size_t      length;
    int         cpu_id;
} init_arg;

static double
now_sec(void)
{
    struct timespec ts;

    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0)
    {
        perror("clock_gettime");
        exit(EXIT_FAILURE);
    }

    return (double) ts.tv_sec + (double) ts.tv_nsec / 1000000000.0;
}

static void
usage(const char *progname)
{
    fprintf(stderr,
            "usage: %s [-m copy|read] [-s size] [-r rounds] [-w warmups] "
            "[-a alignment] [-t threads] [-p none|packed|spread] [-c cpus]\n"
            "\n"
            "options:\n"
            "  -m mode       benchmark mode: copy or read, default copy\n"
            "  -s size       copy size, suffix supports K/M/G/T, default 1G\n"
            "  -r rounds     measured rounds, default 10\n"
            "  -w warmups    warmup rounds before measurement, default 3\n"
            "  -a alignment  allocation alignment in bytes, default 64\n"
            "  -t threads    worker thread count, default 1\n"
            "  -p policy     thread placement: none, packed, spread; default spread\n"
            "  -c cpus       CPU list, for example 0-31 or 0,4,8,12\n"
            "\n"
            "copy mode reports GiB/s for copied payload. The approximate\n"
            "read+write memory traffic is 2x that number for ordinary memcpy.\n"
            "read mode reports GiB/s for bytes read from the source buffer.\n",
            progname);
}

static int
parse_u64(const char *arg, uint64_t *out)
{
    char       *endptr;
    uint64_t    value;

    errno = 0;
    value = strtoull(arg, &endptr, 10);
    if (errno != 0 || endptr == arg || *endptr != '\0')
        return -1;

    *out = value;
    return 0;
}

static int
parse_size(const char *arg, size_t *out)
{
    char       *endptr;
    uint64_t    value;
    uint64_t    multiplier = 1;

    errno = 0;
    value = strtoull(arg, &endptr, 10);
    if (errno != 0 || endptr == arg)
        return -1;

    if (*endptr != '\0')
    {
        if (endptr[1] != '\0')
            return -1;

        switch (*endptr)
        {
            case 'k':
            case 'K':
                multiplier = 1024ULL;
                break;
            case 'm':
            case 'M':
                multiplier = 1024ULL * 1024ULL;
                break;
            case 'g':
            case 'G':
                multiplier = 1024ULL * 1024ULL * 1024ULL;
                break;
            case 't':
            case 'T':
                multiplier = 1024ULL * 1024ULL * 1024ULL * 1024ULL;
                break;
            default:
                return -1;
        }
    }

    if (value > UINT64_MAX / multiplier)
        return -1;
    value *= multiplier;

    if ((uint64_t) (size_t) value != value)
        return -1;

    *out = (size_t) value;
    return 0;
}

static int
is_power_of_two(size_t value)
{
    return value != 0 && (value & (value - 1)) == 0;
}

static const char *
mode_name(bench_mode mode)
{
    switch (mode)
    {
        case BENCH_MODE_COPY:
            return "copy";
        case BENCH_MODE_READ:
            return "read";
    }

    return "unknown";
}

static const char *
place_name(place_policy place)
{
    switch (place)
    {
        case PLACE_NONE:
            return "none";
        case PLACE_PACKED:
            return "packed";
        case PLACE_SPREAD:
            return "spread";
    }

    return "unknown";
}

static int
parse_mode(const char *arg, bench_mode *mode)
{
    if (strcmp(arg, "copy") == 0)
    {
        *mode = BENCH_MODE_COPY;
        return 0;
    }

    if (strcmp(arg, "read") == 0)
    {
        *mode = BENCH_MODE_READ;
        return 0;
    }

    return -1;
}

static int
parse_place(const char *arg, place_policy *place)
{
    if (strcmp(arg, "none") == 0)
    {
        *place = PLACE_NONE;
        return 0;
    }

    if (strcmp(arg, "packed") == 0)
    {
        *place = PLACE_PACKED;
        return 0;
    }

    if (strcmp(arg, "spread") == 0)
    {
        *place = PLACE_SPREAD;
        return 0;
    }

    return -1;
}

static int
build_cpu_list(int **cpus_out, int *cpu_count_out)
{
#ifdef __linux__
    cpu_set_t   allowed;
    int        *cpus;
    int         cpu_count = 0;

    if (sched_getaffinity(0, sizeof(allowed), &allowed) != 0)
        return -1;

    cpus = calloc(CPU_SETSIZE, sizeof(int));
    if (cpus == NULL)
        return -1;

    for (int i = 0; i < CPU_SETSIZE; i++)
    {
        if (CPU_ISSET(i, &allowed))
            cpus[cpu_count++] = i;
    }

    if (cpu_count == 0)
    {
        free(cpus);
        return -1;
    }

    *cpus_out = cpus;
    *cpu_count_out = cpu_count;
    return 0;
#else
    (void) cpus_out;
    (void) cpu_count_out;

    return -1;
#endif
}

static int
append_cpu(int **cpus, int *cpu_count, int *cpu_capacity, int cpu)
{
    int        *new_cpus;

    if (*cpu_count >= *cpu_capacity)
    {
        int         new_capacity = *cpu_capacity == 0 ? 16 : *cpu_capacity * 2;

        new_cpus = realloc(*cpus, (size_t) new_capacity * sizeof(int));
        if (new_cpus == NULL)
            return -1;

        *cpus = new_cpus;
        *cpu_capacity = new_capacity;
    }

    (*cpus)[(*cpu_count)++] = cpu;
    return 0;
}

static int
parse_cpu_list(const char *arg, int **cpus_out, int *cpu_count_out)
{
    const char *ptr = arg;
    int        *cpus = NULL;
    int         cpu_count = 0;
    int         cpu_capacity = 0;

    while (*ptr != '\0')
    {
        char       *endptr;
        unsigned long start;
        unsigned long end;

        errno = 0;
        start = strtoul(ptr, &endptr, 10);
        if (errno != 0 || endptr == ptr || start > INT32_MAX)
            goto fail;

        end = start;
        if (*endptr == '-')
        {
            ptr = endptr + 1;
            errno = 0;
            end = strtoul(ptr, &endptr, 10);
            if (errno != 0 || endptr == ptr || end > INT32_MAX || end < start)
                goto fail;
        }

        for (unsigned long cpu = start; cpu <= end; cpu++)
        {
            if (append_cpu(&cpus, &cpu_count, &cpu_capacity, (int) cpu) != 0)
                goto fail;
        }

        if (*endptr == ',')
            ptr = endptr + 1;
        else if (*endptr == '\0')
            ptr = endptr;
        else
            goto fail;
    }

    if (cpu_count == 0)
        goto fail;

    *cpus_out = cpus;
    *cpu_count_out = cpu_count;
    return 0;

fail:
    free(cpus);
    return -1;
}

static int
choose_cpu(const int *cpus, int cpu_count, int threads, int worker_id,
           place_policy place)
{
    int         index;

    if (place == PLACE_NONE || cpus == NULL || cpu_count == 0)
        return -1;

    if (place == PLACE_PACKED)
        index = worker_id % cpu_count;
    else
        index = (int) (((uint64_t) worker_id * (uint64_t) cpu_count) /
                       (uint64_t) threads);

    if (index >= cpu_count)
        index = cpu_count - 1;

    return cpus[index];
}

static void
pin_current_thread(int cpu_id)
{
#ifdef __linux__
    cpu_set_t   set;

    if (cpu_id < 0)
        return;

    CPU_ZERO(&set);
    CPU_SET(cpu_id, &set);
    (void) pthread_setaffinity_np(pthread_self(), sizeof(set), &set);
#else
    (void) cpu_id;
#endif
}

static uint64_t
read_buffer_sum(const unsigned char *src, size_t length)
{
    const uint64_t *words = (const uint64_t *) src;
    size_t      nwords = length / sizeof(uint64_t);
    uint64_t    a0 = 0;
    uint64_t    a1 = 0;
    uint64_t    a2 = 0;
    uint64_t    a3 = 0;
    uint64_t    a4 = 0;
    uint64_t    a5 = 0;
    uint64_t    a6 = 0;
    uint64_t    a7 = 0;
    size_t      i = 0;

    for (; i + 8 <= nwords; i += 8)
    {
        a0 += words[i + 0];
        a1 += words[i + 1];
        a2 += words[i + 2];
        a3 += words[i + 3];
        a4 += words[i + 4];
        a5 += words[i + 5];
        a6 += words[i + 6];
        a7 += words[i + 7];
    }

    for (; i < nwords; i++)
        a0 += words[i];

    for (i = nwords * sizeof(uint64_t); i < length; i++)
        a1 += src[i];

    return a0 ^ a1 ^ a2 ^ a3 ^ a4 ^ a5 ^ a6 ^ a7;
}

static uint64_t
read_buffer(const unsigned char *src, size_t length)
{
#if defined(__aarch64__)
    const unsigned char *ptr = src;
    const unsigned char *end = src + (length & ~(size_t) 255);

    while (ptr < end)
    {
        __asm__ __volatile__(
            "prfm pldl1keep, [%[p], #512]\n\t"
            "ldp q0, q1, [%[p], #0]\n\t"
            "ldp q2, q3, [%[p], #32]\n\t"
            "ldp q4, q5, [%[p], #64]\n\t"
            "ldp q6, q7, [%[p], #96]\n\t"
            "ldp q8, q9, [%[p], #128]\n\t"
            "ldp q10, q11, [%[p], #160]\n\t"
            "ldp q12, q13, [%[p], #192]\n\t"
            "ldp q14, q15, [%[p], #224]\n\t"
            :
            : [p] "r" (ptr)
            : "memory",
              "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7",
              "v8", "v9", "v10", "v11", "v12", "v13", "v14", "v15");
        ptr += 256;
    }

    return (uint64_t) length ^ read_buffer_sum(ptr, (size_t) (src + length - ptr));
#else
    return read_buffer_sum(src, length);
#endif
}

static void *
worker_main(void *arg)
{
    worker_arg *worker = (worker_arg *) arg;
    unsigned char *src = worker->src + worker->offset;
    unsigned char *dst = worker->dst ? worker->dst + worker->offset : NULL;
    uint64_t    checksum = 0;

    pin_current_thread(worker->cpu_id);

    for (uint64_t i = 0; i < worker->loops; i++)
    {
        pthread_barrier_wait(worker->start_barrier);

        if (worker->mode == BENCH_MODE_COPY)
        {
            memcpy(dst, src, worker->length);
            checksum ^= dst[(i * 4096) % worker->length];
        }
        else
            checksum ^= read_buffer(src, worker->length);

        pthread_barrier_wait(worker->end_barrier);
    }

    worker->checksums[worker->worker_id] = checksum;

    return NULL;
}

static void *
init_worker_main(void *arg)
{
    init_arg   *worker = (init_arg *) arg;

    pin_current_thread(worker->cpu_id);

    memset(worker->src + worker->offset, 0xa5, worker->length);
    if (worker->dst)
        memset(worker->dst + worker->offset, 0x00, worker->length);

    return NULL;
}

int
main(int argc, char **argv)
{
    bench_mode  mode = BENCH_MODE_COPY;
    place_policy place = PLACE_SPREAD;
    size_t      size = 1024ULL * 1024ULL * 1024ULL;
    uint64_t    rounds = 10;
    uint64_t    warmups = 3;
    size_t      alignment = 64;
    uint64_t    threads_arg = 1;
    int         threads;
    int         opt;
    unsigned char *src = NULL;
    unsigned char *dst = NULL;
    volatile uint64_t sink = 0;
    double      best_sec = 1.0e100;
    double      total_sec = 0.0;
    double     *elapsed;
    uint64_t   *checksums;
    pthread_t  *workers;
    worker_arg *worker_args;
    init_arg   *init_args;
    int        *cpus = NULL;
    int         cpu_count = 0;
    const char *cpu_list_arg = NULL;
    pthread_barrier_t start_barrier;
    pthread_barrier_t end_barrier;

    while ((opt = getopt(argc, argv, "m:s:r:w:a:t:p:c:h")) != -1)
    {
        uint64_t value;

        switch (opt)
        {
            case 'm':
                if (parse_mode(optarg, &mode) != 0)
                {
                    fprintf(stderr, "invalid mode: %s\n", optarg);
                    return EXIT_FAILURE;
                }
                break;
            case 's':
                if (parse_size(optarg, &size) != 0 || size == 0)
                {
                    fprintf(stderr, "invalid size: %s\n", optarg);
                    return EXIT_FAILURE;
                }
                break;
            case 'r':
                if (parse_u64(optarg, &rounds) != 0 || rounds == 0)
                {
                    fprintf(stderr, "invalid rounds: %s\n", optarg);
                    return EXIT_FAILURE;
                }
                break;
            case 'w':
                if (parse_u64(optarg, &warmups) != 0)
                {
                    fprintf(stderr, "invalid warmups: %s\n", optarg);
                    return EXIT_FAILURE;
                }
                break;
            case 'a':
                if (parse_u64(optarg, &value) != 0 ||
                    value == 0 ||
                    (uint64_t) (size_t) value != value)
                {
                    fprintf(stderr, "invalid alignment: %s\n", optarg);
                    return EXIT_FAILURE;
                }
                alignment = (size_t) value;
                break;
            case 't':
                if (parse_u64(optarg, &threads_arg) != 0 ||
                    threads_arg == 0 ||
                    threads_arg > INT32_MAX)
                {
                    fprintf(stderr, "invalid threads: %s\n", optarg);
                    return EXIT_FAILURE;
                }
                break;
            case 'p':
                if (parse_place(optarg, &place) != 0)
                {
                    fprintf(stderr, "invalid placement policy: %s\n", optarg);
                    return EXIT_FAILURE;
                }
                break;
            case 'c':
                cpu_list_arg = optarg;
                break;
            case 'h':
                usage(argv[0]);
                return EXIT_SUCCESS;
            default:
                usage(argv[0]);
                return EXIT_FAILURE;
        }
    }

    if (!is_power_of_two(alignment) || alignment < sizeof(void *))
    {
        fprintf(stderr,
                "alignment must be a power of two and at least sizeof(void*)\n");
        return EXIT_FAILURE;
    }

    if (size < threads_arg)
    {
        fprintf(stderr, "size must be at least as large as thread count\n");
        return EXIT_FAILURE;
    }

    threads = (int) threads_arg;

    if (cpu_list_arg != NULL)
    {
        if (parse_cpu_list(cpu_list_arg, &cpus, &cpu_count) != 0)
        {
            fprintf(stderr, "invalid CPU list: %s\n", cpu_list_arg);
            return EXIT_FAILURE;
        }
    }
    else if (place != PLACE_NONE && build_cpu_list(&cpus, &cpu_count) != 0)
    {
        fprintf(stderr, "failed to read CPU affinity mask for placement\n");
        return EXIT_FAILURE;
    }

    if (posix_memalign((void **) &src, alignment, size) != 0)
    {
        fprintf(stderr, "failed to allocate source buffer of %zu bytes\n", size);
        return EXIT_FAILURE;
    }

    if (mode == BENCH_MODE_COPY &&
        posix_memalign((void **) &dst, alignment, size) != 0)
    {
        fprintf(stderr, "failed to allocate destination buffer of %zu bytes\n", size);
        free(src);
        return EXIT_FAILURE;
    }

    elapsed = calloc(rounds, sizeof(double));
    checksums = calloc(threads, sizeof(uint64_t));
    workers = calloc(threads, sizeof(pthread_t));
    worker_args = calloc(threads, sizeof(worker_arg));
    init_args = calloc(threads, sizeof(init_arg));
    if (elapsed == NULL || checksums == NULL ||
        workers == NULL || worker_args == NULL || init_args == NULL)
    {
        fprintf(stderr, "failed to allocate worker state\n");
        free(src);
        free(dst);
        free(elapsed);
        free(checksums);
        free(workers);
        free(worker_args);
        free(init_args);
        free(cpus);
        return EXIT_FAILURE;
    }

    for (int i = 0; i < threads; i++)
    {
        size_t      start = (size / (size_t) threads) * (size_t) i;
        size_t      end = (i == threads - 1) ?
                          size :
                          (size / (size_t) threads) * (size_t) (i + 1);

        init_args[i].src = src;
        init_args[i].dst = dst;
        init_args[i].offset = start;
        init_args[i].length = end - start;
        init_args[i].cpu_id = choose_cpu(cpus, cpu_count, threads, i, place);

        if (pthread_create(&workers[i], NULL, init_worker_main,
                           &init_args[i]) != 0)
        {
            fprintf(stderr, "failed to create init worker thread %d\n", i);
            return EXIT_FAILURE;
        }
    }

    for (int i = 0; i < threads; i++)
    {
        if (pthread_join(workers[i], NULL) != 0)
        {
            fprintf(stderr, "failed to join init worker thread %d\n", i);
            return EXIT_FAILURE;
        }
    }

    if (pthread_barrier_init(&start_barrier, NULL, threads + 1) != 0 ||
        pthread_barrier_init(&end_barrier, NULL, threads + 1) != 0)
    {
        fprintf(stderr, "failed to initialize thread barriers\n");
        free(src);
        free(dst);
        free(elapsed);
        free(checksums);
        free(workers);
        free(worker_args);
        free(init_args);
        free(cpus);
        return EXIT_FAILURE;
    }

    for (int i = 0; i < threads; i++)
    {
        size_t      start = (size / (size_t) threads) * (size_t) i;
        size_t      end = (i == threads - 1) ?
                          size :
                          (size / (size_t) threads) * (size_t) (i + 1);

        worker_args[i].mode = mode;
        worker_args[i].src = src;
        worker_args[i].dst = dst;
        worker_args[i].offset = start;
        worker_args[i].length = end - start;
        worker_args[i].loops = warmups + rounds;
        worker_args[i].warmups = warmups;
        worker_args[i].checksums = checksums;
        worker_args[i].start_barrier = &start_barrier;
        worker_args[i].end_barrier = &end_barrier;
        worker_args[i].worker_id = i;
        worker_args[i].cpu_id = choose_cpu(cpus, cpu_count, threads, i, place);

        if (pthread_create(&workers[i], NULL, worker_main, &worker_args[i]) != 0)
        {
            fprintf(stderr, "failed to create worker thread %d\n", i);
            return EXIT_FAILURE;
        }
    }

    for (uint64_t i = 0; i < warmups + rounds; i++)
    {
        double      start;
        double      end;

        pthread_barrier_wait(&start_barrier);
        start = now_sec();
        pthread_barrier_wait(&end_barrier);
        end = now_sec();

        if (i >= warmups)
            elapsed[i - warmups] = end - start;
    }

    for (int i = 0; i < threads; i++)
    {
        if (pthread_join(workers[i], NULL) != 0)
        {
            fprintf(stderr, "failed to join worker thread %d\n", i);
            return EXIT_FAILURE;
        }
        sink ^= checksums[i];
    }

    for (uint64_t i = 0; i < rounds; i++)
    {
        total_sec += elapsed[i];
        if (elapsed[i] < best_sec)
            best_sec = elapsed[i];
    }

    pthread_barrier_destroy(&start_barrier);
    pthread_barrier_destroy(&end_barrier);

    {
        const double gib = (double) size / (1024.0 * 1024.0 * 1024.0);
        const double best_payload_gib_s = gib / best_sec;
        const double avg_payload_gib_s = gib / (total_sec / (double) rounds);

        printf("mode:                %s\n", mode_name(mode));
        printf("size:                %zu bytes (%.3f GiB)\n", size, gib);
        printf("alignment:           %zu bytes\n", alignment);
        printf("threads:             %d\n", threads);
        printf("placement:           %s", place_name(place));
        if (place != PLACE_NONE)
            printf(" (%d CPUs available)", cpu_count);
        printf("\n");
        printf("warmups:             %" PRIu64 "\n", warmups);
        printf("rounds:              %" PRIu64 "\n", rounds);
        printf("best %s time:        %.6f s\n", mode_name(mode), best_sec);
        printf("avg %s time:         %.6f s\n", mode_name(mode),
               total_sec / (double) rounds);
        printf("best payload bw:     %.2f GiB/s\n", best_payload_gib_s);
        printf("avg payload bw:      %.2f GiB/s\n", avg_payload_gib_s);
        if (mode == BENCH_MODE_COPY)
        {
            printf("best read+write bw:  %.2f GiB/s (approx)\n",
                   best_payload_gib_s * 2.0);
            printf("avg read+write bw:   %.2f GiB/s (approx)\n",
                   avg_payload_gib_s * 2.0);
        }
        printf("checksum sink:       %" PRIu64 "\n", sink);
    }

    free(src);
    free(dst);
    free(elapsed);
    free(checksums);
    free(workers);
    free(worker_args);
    free(init_args);
    free(cpus);

    return EXIT_SUCCESS;
}
