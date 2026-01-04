#include <arpa/inet.h>
#include <netinet/in.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/epoll.h>
#include <time.h>
#include <unistd.h>

//#define DEBUG

#include "common.h"

int keep_running = 1;

void handler(int sig) {
	keep_running = 0;
}

typedef struct {
    uint64_t buckets[8][10]; // UNIT_USEC, TEN_USEC, HUNDRED_USEC...
    uint64_t over_100_secs;
} histogram_t;

void handle_alarm(int sig) {
    keep_running = 0;
}

static void record_latency(histogram_t *h, uint64_t usec) {
    if (usec >= 100000000) {
		h->over_100_secs++;
		return;
	}

    int magnitude = 0;
    uint64_t temp = usec;
    while (temp >= 10 && magnitude < 7) {
        temp /= 10;
        magnitude++;
    }
    h->buckets[magnitude][temp < 10 ? temp : 9]++;
}

static void print_histogram(histogram_t *h) {
    const char *labels[] = {"UNIT_USEC", "TEN_USEC", "HUNDRED_USEC", "UNIT_MSEC", "TEN_MSEC", "HUNDRED_MSEC", "UNIT_SEC", "TEN_SEC"};
    printf("\nHistogram of request/response times\n");
    for (int i = 0; i < 8; i++) {
        printf("%-14s: ", labels[i]);
        for (int j = 0; j < 10; j++) printf("%4lu: ", h->buckets[i][j]);
        printf("\n");
    }
    printf(">100_SECS: %lu\n", h->over_100_secs);
}

uint64_t get_usec() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000 + ts.tv_nsec / 1000;
}

int main(int argc, char *argv[]) {
    if (argc < 6) {
		printf("Usage: %s <server_ip> <req_size> <resp_size> <header_first:1> <time(s)>\n", argv[0]);
		return 1;
	}

    char *ip = argv[1];
    int req_sz = atoi(argv[2]);
    int res_sz = atoi(argv[3]);
    int header = atoi(argv[4]);
    int duration = atoi(argv[5]);

	signal(SIGINT, handle_alarm);  // 支持 Ctrl+C 手动停止
    signal(SIGALRM, handle_alarm); // 支持定时停止

    int sock = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in serv_addr = {
		.sin_family = AF_INET,
		.sin_port = htons(default_port)
	};

    inet_pton(AF_INET, ip, &serv_addr.sin_addr);
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
		perror("connect failed");
        return 1;
	}

	optimize_socket(sock);
    int epoll_fd = epoll_create1(0);
    struct epoll_event ev = {
		.events = EPOLLIN,
		.data.fd = sock
	};

    epoll_ctl(epoll_fd, EPOLL_CTL_ADD, sock, &ev);

    char *req_buf = malloc(req_sz);
    char *res_buf = malloc(res_sz);
    histogram_t hist = {0};
    uint64_t total_trans = 0;

	printf("start: %d reqsize <-> %d respsize, header:%d duration %d s...\n", req_sz, res_sz, header, duration);

	alarm(duration);

    uint64_t start_test_time = get_usec();
    while (keep_running) {
        uint64_t t1 = get_usec();
        if (send(sock, req_buf, req_sz, 0) <= 0) {
			perror("send error!");
			break; // 发送 Request
		}
		DEBUG_LOG("%d bytes sent!\n", req_sz);

		// send with flag=0 is equivalent with write, simuldate additional payload
		if (header > 0) {
			if (send(sock, req_buf, payload_sz, 0) <= 0) {
				perror("send error!");
				break; // 发送 Request
			}
			DEBUG_LOG("%d bytes sent!\n", payload_sz);
		}

        struct epoll_event events[1];
		int nfds = epoll_wait(epoll_fd, events, 1, 1000); // 1秒超时
        if (nfds > 0) {
			// expect two adjacent write is treated as two packets
            int received = 0;
			int expected = res_sz;
			if (header > 0)
				expected *= 2;
            while(received < expected && keep_running) {
                int n = recv(sock, res_buf + received, expected - received, 0);
				DEBUG_LOG("%d bytes received!\n", n);
                if (n <= 0) {
					perror("incomplete received!");
					keep_running = 0;
					break;
				}
				received += n;
            }
			if (received == expected) {
				uint64_t t2 = get_usec();
				record_latency(&hist, t2 - t1);
				total_trans++;
			}
        } else if (nfds == 0) {
			perror("timeout!");
			continue;
		} else {
			perror("alarm received!");
			break;
		}
    }

    uint64_t end_test_time = get_usec();
	double real_duration = (end_test_time - start_test_time) / 1000000.0;

    // 输出统计结果 (Netperf 风格)
    printf("\n测试结束.\n");
    printf("Interim result: %.2f Trans/s over %.3f seconds\n",
            total_trans / real_duration, real_duration);

    printf("\nLocal /Remote\nSocket Size   Request  Resp.    Elapsed  Trans.\nSend   Recv   Size     Size     Time     Rate\nbytes  Bytes  bytes    bytes    secs.    per sec\n");
    printf("16384  131072 %-8d %-8d %-8.2f %.2f\n",
            req_sz, res_sz, real_duration, total_trans / real_duration);

    printf("\nRoundTrip Latency: %.3f usec/Tran\n",
            total_trans > 0 ? (double)(end_test_time - start_test_time) / total_trans : 0);

    print_histogram(&hist);

    close(sock);
    free(req_buf);
    free(res_buf);
    return 0;
}
