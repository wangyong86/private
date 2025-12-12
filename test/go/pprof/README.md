#memory
go tool pprof -inuse_space http://localhost:8080/debug/pprof/heap
(pprof) top : most memory alloc function
(pprof) top -alloc_space
(pprof) top -inuse_space
(pprof) top -alloc_objects
(pprof) top -inuse_objects

#cpu
* go tool pprof http://localhost:8080/debug/pprof/profile
* flame graph: go tool pprof -http=:8000 http://127.0.0.1:6060/debug/pprof/profile


# stac
* go tool pprof http://localhost:8080/debug/pprof/goroutine
* (pprof) traces
