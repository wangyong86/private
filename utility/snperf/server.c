#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <unistd.h>

//#define DEBUG

#include "common.h"

#define MAX_EVENTS 1024

int main(int argc, char *argv[]) {
    int port = default_port;
    int resp_size = 4096; // 默认回包大小
    if (argc > 1)
        resp_size = atoi(argv[1]);

    int listen_fd = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in addr = {
        .sin_family = AF_INET,
        .sin_port = htons(port),
        .sin_addr.s_addr = INADDR_ANY
    };

    bind(listen_fd, (struct sockaddr *)&addr, sizeof(addr));
    listen(listen_fd, 128);
    set_nonblocking(listen_fd);

    int epoll_fd = epoll_create1(0);
    struct epoll_event ev, events[MAX_EVENTS];
    ev.events = EPOLLIN;
    ev.data.fd = listen_fd;
    epoll_ctl(epoll_fd, EPOLL_CTL_ADD, listen_fd, &ev);

    print_tcp_parameter(listen_fd);
    printf("server started, resp_sz:%d, port:%d\n", resp_size, port);
    char *buf = malloc(65536);
    while (1) {
        int nfds = epoll_wait(epoll_fd, events, MAX_EVENTS, -1);
        for (int n = 0; n < nfds; n++) {
            if (events[n].data.fd == listen_fd) {
                int conn_fd = accept(listen_fd, NULL, NULL);
                set_nonblocking(conn_fd);
                optimize_socket(conn_fd);
                ev.events = EPOLLIN | EPOLLET;
                ev.data.fd = conn_fd;
                epoll_ctl(epoll_fd, EPOLL_CTL_ADD, conn_fd, &ev);
            } else {
                int fd = events[n].data.fd;
                int nread = read(fd, buf, 65536);
                if (nread <= 0) {
                    DEBUG_LOG("close fd: %d", fd);
                    close(fd);
                } else {
                    DEBUG_LOG("%d bytes received!\n", nread);
                    // Ping-Pong: 收到请求后立即发送固定大小回包
                    int response_sz = resp_size;
                    if (nread > payload_sz)
                        response_sz *= 2;
                    write(fd, buf, response_sz);
                    DEBUG_LOG("%d bytes reponsed!\n", response_sz);
                }
            }
        }
    }
    return 0;
}
