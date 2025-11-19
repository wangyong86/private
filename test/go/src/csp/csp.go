package main

import (
	"example.com/wytest/server"
	"log"
	"net"
	"os"
)

func main() {
	if len(os.Args) != 2 {
		log.Fatal("parameter must be 2, result:", len(os.Args))
	}

	var port = "localhost:" + os.Args[1]
	listener, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatal(err)
	}
	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Print(err) // e.g., connection aborted
			continue
		}
		go server.HandleConn(conn) // handle one connection at a time
	}
}
