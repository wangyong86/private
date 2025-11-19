package main

import (
	"example.com/wytest/server"
	"log"
	"net"
	"os"
	"time"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("parameter must greater than 2, result:", len(os.Args))
	}

	for i := 1; i < len(os.Args); i++ {
		go GetTime(os.Args[i])
	}

	for true {
		time.Sleep(1 * time.Second)
	}
}

func GetTime(port string) {
	var connstr = "localhost:" + port
	conn, err := net.Dial("tcp", connstr)
	if err != nil {
		log.Fatal(err)
	}

	defer conn.Close()
	server.MustCopy(port, os.Stdout, conn)
}
