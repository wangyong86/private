extern int default_port;
extern int payload_sz;

#if defined(DEBUG)
#define DEBUG_LOG(...) printf(__VA_ARGS__)
#else
#define DEBUG_LOG(...)
#endif

extern void optimize_socket(int fd);
extern void set_nonblocking(int sock);
extern void print_tcp_parameter(int sock);
