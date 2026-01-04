#include "common.h"

#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <sys/socket.h>
#include <stdio.h>

int default_port = 12685;
int payload_sz = 20;

void optimize_socket(int fd)
{
	int on = 1;

	// 1. disable Nagle (TCP_NODELAY)
    // 强制立即发送数据包，即使数据包很小
    if (setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &on, sizeof(on)) < 0) {
        printf("setsockopt TCP_NODELAY failed");
    }

#if 0
    if (setsockopt(fd, IPPROTO_TCP, TCP_QUICKACK, &on, sizeof(on)) < 0) {
        printf("setsockopt TCP_QUICKACK failed");
    }
#endif
}

void set_nonblocking(int sock) {
    int opts = fcntl(sock, F_GETFL);
    fcntl(sock, F_SETFL, opts | O_NONBLOCK);
}

void print_tcp_parameter(int sockfd) {
    int optval;
    socklen_t optlen = sizeof(optval);

#define _STR(str) #str
#define PARAM_STR(str) const char *str = #str
    PARAM_STR(CORK);
    PARAM_STR(NODELAY);
    PARAM_STR(QUICKACK);
    
    // 获取 TCP_CORK 的值
    if (getsockopt(sockfd, SOL_TCP, TCP_CORK, &optval, &optlen) < 0)
        printf("getsockopt %s failed, %d\n", _STR(CORK), errno);
    else
	printf("%s: %s\n", _STR(TCP_CORK), optval ? "ON" : "OFF");

    if (getsockopt(sockfd, SOL_TCP, TCP_NODELAY, &optval, &optlen) < 0)
        printf("getsockopt %s failed, %d\n", _STR(NODELAY), errno);
    else
	printf("%s: %s\n", _STR(TCP_NODELAY), optval ? "ON" : "OFF");

    if (getsockopt(sockfd, SOL_TCP, TCP_QUICKACK, &optval, &optlen) < 0)
        printf("getsockopt %s failed, %d\n", _STR(QUICKACK), errno);
    else
	printf("%s: %s\n", _STR(TCP_QUICKACK), optval ? "ON" : "OFF");
}
