target	= server client
objs	= common.o \
		  server.o \
		  client.o
common	= common.o

.PHONY: all clean

all: $(target)

%.o: %.c
	gcc -g3 -O3 -c $< -o $@

common.o: common.c
	gcc -g3 -O3 -c common.c -o common.o

server: server.o $(common)
	gcc -g3 -O3 $^ -o server

client: client.o $(common)
	gcc -g3 -O3 $^ -o $@

clean:
	rm -f $(objs) $(target)
