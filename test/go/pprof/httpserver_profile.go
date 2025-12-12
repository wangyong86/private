package main

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	_ "net/http/pprof" // 关键：自动注册pprof处理器
	"runtime"
	"sync"
	"time"
)

// User 结构体
type User struct {
	ID        int       `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	CreatedAt time.Time `json:"created_at"`
	Data      []byte    `json:"-"` // 模拟大内存占用
}

// Order 结构体
type Order struct {
	ID         int     `json:"id"`
	UserID     int     `json:"user_id"`
	Amount     float64 `json:"amount"`
	Items      []Item  `json:"items"`
	Processing bool    `json:"-"`
}

// Item 结构体
type Item struct {
	ProductID int     `json:"product_id"`
	Quantity  int     `json:"quantity"`
	Price     float64 `json:"price"`
}

// 全局状态
var (
	users      = make(map[int]*User)
	usersMutex sync.RWMutex
	orders     = make(map[int]*Order)
	ordersMutex sync.RWMutex
	
	// 模拟内存泄漏：故意保留的引用
	leakedUsers []*User
	
	// Goroutine泄漏
	goroutineCounter int
	goroutineMutex   sync.Mutex
	
	// 阻塞模拟
	globalLock sync.Mutex
)

// init 初始化一些测试数据
func init() {
	// 初始化一些用户
	for i := 1; i <= 1000; i++ {
		users[i] = &User{
			ID:        i,
			Name:      fmt.Sprintf("User%d", i),
			Email:     fmt.Sprintf("user%d@example.com", i),
			CreatedAt: time.Now(),
			Data:      make([]byte, 1024*10), // 每个用户10KB数据
		}
	}
	
	// 初始化一些订单
	for i := 1; i <= 500; i++ {
		items := make([]Item, rand.Intn(5)+1)
		for j := range items {
			items[j] = Item{
				ProductID: rand.Intn(1000),
				Quantity:  rand.Intn(10) + 1,
				Price:     rand.Float64() * 100,
			}
		}
		
		orders[i] = &Order{
			ID:     i,
			UserID: rand.Intn(1000) + 1,
			Amount: rand.Float64() * 1000,
			Items:  items,
		}
	}
	
	// 启动一些后台任务
	go memoryLeakSimulator()
	go cpuIntensiveTask()
	go goroutineLeakSimulator()
	go blockingOperationSimulator()
}

// ==================== 业务处理函数 ====================

// 模拟内存泄漏：故意保留不再使用的用户引用
func memoryLeakSimulator() {
	ticker := time.NewTicker(2 * time.Second)
	defer ticker.Stop()
	
	for range ticker.C {
		// 创建一个新用户但不放入map，只放入leakedUsers
		user := &User{
			ID:        rand.Intn(1000000),
			Name:      fmt.Sprintf("LeakedUser%d", rand.Intn(10000)),
			Email:     fmt.Sprintf("leaked%d@example.com", rand.Intn(10000)),
			CreatedAt: time.Now(),
			Data:      make([]byte, 1024*50), // 50KB
		}
		
		// 故意保留引用，模拟内存泄漏
		leakedUsers = append(leakedUsers, user)
		
		// 只保留最近1000个，防止内存爆炸
		if len(leakedUsers) > 1000 {
			leakedUsers = leakedUsers[500:] // 仍然保留一半，模拟泄漏
		}
		
		log.Printf("内存泄漏模拟: 当前泄漏用户数: %d", len(leakedUsers))
	}
}

// CPU密集型任务：斐波那契数列计算
func cpuIntensiveTask() {
	ticker := time.NewTicker(3 * time.Second)
	defer ticker.Stop()
	
	for range ticker.C {
		go func() {
			n := 35 + rand.Intn(10) // 计算较大的斐波那契数
			start := time.Now()
			result := fibonacci(n)
			elapsed := time.Since(start)
			
			log.Printf("CPU密集型任务: fib(%d)=%d, 耗时: %v", n, result, elapsed)
		}()
	}
}

func fibonacci(n int) int {
	if n <= 1 {
		return n
	}
	return fibonacci(n-1) + fibonacci(n-2)
}

// Goroutine泄漏模拟：创建不退出的goroutine
func goroutineLeakSimulator() {
	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop()
	
	for range ticker.C {
		goroutineMutex.Lock()
		goroutineCounter++
		id := goroutineCounter
		goroutineMutex.Unlock()
		
		// 启动一个永远不会退出的goroutine
		go func(id int) {
			// 模拟一些工作
			time.Sleep(time.Duration(rand.Intn(3000)) * time.Millisecond)
			
			// 然后进入无限等待（泄漏！）
			select {} // 永远阻塞
		}(id)
		
		log.Printf("Goroutine泄漏模拟: 创建goroutine #%d, 当前总数: %d", 
			id, runtime.NumGoroutine())
	}
}

// 阻塞操作模拟：故意造成锁竞争
func blockingOperationSimulator() {
	ticker := time.NewTicker(10 * time.Second)
	defer ticker.Stop()
	
	for range ticker.C {
		// 同时启动多个goroutine竞争全局锁
		for i := 0; i < 5; i++ {
			go func(id int) {
				log.Printf("阻塞模拟 %d: 等待获取锁", id)
				start := time.Now()
				
				globalLock.Lock()
				defer globalLock.Unlock()
				
				// 持有锁一段时间
				holdTime := time.Duration(500+rand.Intn(1500)) * time.Millisecond
				time.Sleep(holdTime)
				
				elapsed := time.Since(start)
				log.Printf("阻塞模拟 %d: 获取锁耗时 %v，持有 %v", id, elapsed, holdTime)
			}(i)
		}
	}
}

// ==================== HTTP处理器 ====================

// 获取所有用户
func getAllUsers(w http.ResponseWriter, r *http.Request) {
	usersMutex.RLock()
	defer usersMutex.RUnlock()
	
	// 模拟一些处理时间
	time.Sleep(time.Duration(rand.Intn(100)) * time.Millisecond)
	
	userList := make([]*User, 0, len(users))
	for _, user := range users {
		userList = append(userList, user)
	}
	
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(userList)
}

// 获取用户详情
func getUserByID(w http.ResponseWriter, r *http.Request) {
	id := rand.Intn(1000) + 1
	
	usersMutex.RLock()
	user, exists := users[id]
	usersMutex.RUnlock()
	
	if !exists {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}
	
	// 模拟CPU密集型处理
	processUserData(user)
	
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

func processUserData(user *User) {
	// 模拟数据处理
	for i := 0; i < 1000; i++ {
		_ = len(user.Name) * len(user.Email)
	}
}

// 创建订单
func createOrder(w http.ResponseWriter, r *http.Request) {
	var order Order
	if err := json.NewDecoder(r.Body).Decode(&order); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	
	order.ID = rand.Intn(1000000)
	order.Processing = true
	
	// 模拟订单处理
	time.Sleep(time.Duration(rand.Intn(500)) * time.Millisecond)
	
	ordersMutex.Lock()
	orders[order.ID] = &order
	ordersMutex.Unlock()
	
	// 后台处理订单
	go processOrder(&order)
	
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(order)
}

func processOrder(order *Order) {
	// 模拟长时间处理
	time.Sleep(2 * time.Second)
	
	ordersMutex.Lock()
	if o, exists := orders[order.ID]; exists {
		o.Processing = false
	}
	ordersMutex.Unlock()
}

// 搜索服务
func search(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query().Get("q")
	if query == "" {
		http.Error(w, "Query parameter 'q' is required", http.StatusBadRequest)
		return
	}
	
	// 模拟复杂搜索
	results := performSearch(query)
	
	// 模拟大数据集返回
	time.Sleep(time.Duration(rand.Intn(200)) * time.Millisecond)
	
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(results)
}

func performSearch(query string) []string {
	// 模拟搜索算法
	results := make([]string, 0)
	for i := 0; i < 100; i++ {
		// 模拟字符串处理
		s := fmt.Sprintf("Result %d for '%s': %s", 
			i, query, time.Now().Format(time.RFC3339Nano))
		results = append(results, s)
		
		// 模拟内存分配
		_ = make([]byte, 1024)
	}
	return results
}

// 系统状态
func systemStatus(w http.ResponseWriter, r *http.Request) {
	var m runtime.MemStats
	runtime.ReadMemStats(&m)
	
	status := map[string]interface{}{
		"timestamp":        time.Now().Format(time.RFC3339),
		"goroutines":       runtime.NumGoroutine(),
		"memory_alloc_mb":  m.Alloc / 1024 / 1024,
		"total_alloc_mb":   m.TotalAlloc / 1024 / 1024,
		"sys_mb":           m.Sys / 1024 / 1024,
		"num_gc":           m.NumGC,
		"leaked_users":     len(leakedUsers),
		"active_users":     len(users),
		"active_orders":    len(orders),
	}
	
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}

// ==================== 主函数 ====================

func main() {
	// 注册业务路由
	http.HandleFunc("/api/users", getAllUsers)
	http.HandleFunc("/api/user", getUserByID)
	http.HandleFunc("/api/orders", createOrder)
	http.HandleFunc("/api/search", search)
	http.HandleFunc("/api/status", systemStatus)
	
	// 注意：pprof路由已经通过 import _ "net/http/pprof" 自动注册
	// 访问路径是 /debug/pprof/
	
	// 首页
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		html := `
		<!DOCTYPE html>
		<html>
		<head>
			<title>Go pprof Demo</title>
			<style>
				body { font-family: Arial, sans-serif; margin: 40px; }
				h1 { color: #333; }
				.menu { margin: 20px 0; }
				.menu a {
					display: inline-block;
					margin: 5px;
					padding: 10px 20px;
					background: #4CAF50;
					color: white;
					text-decoration: none;
					border-radius: 5px;
				}
				.menu a:hover { background: #45a049; }
				.info { background: #f5f5f5; padding: 15px; border-radius: 5px; }
			</style>
		</head>
		<body>
			<h1>Go pprof 性能分析演示</h1>
			
			<div class="info">
				<p><strong>服务器地址:</strong> http://localhost:8080</p>
				<p><strong>启动时间:</strong> %s</p>
				<p><strong>当前Goroutines:</strong> %d</p>
			</div>
			
			<div class="menu">
				<h3>业务API:</h3>
				<a href="/api/users">获取用户列表</a>
				<a href="/api/user">获取随机用户</a>
				<a href="/api/search?q=test">搜索测试</a>
				<a href="/api/status">系统状态</a>
			</div>
			
			<div class="menu">
				<h3>pprof 分析端点:</h3>
				<a href="/debug/pprof/">pprof 主页</a>
				<a href="/debug/pprof/heap">内存分析</a>
				<a href="/debug/pprof/profile?seconds=30">CPU分析(30秒)</a>
				<a href="/debug/pprof/goroutine">Goroutine分析</a>
				<a href="/debug/pprof/block">阻塞分析</a>
				<a href="/debug/pprof/mutex">锁竞争分析</a>
				<a href="/debug/pprof/threadcreate">线程分析</a>
				<a href="/debug/pprof/trace?seconds=5">执行追踪(5秒)</a>
			</div>
			
			<div class="menu">
				<h3>命令行工具:</h3>
				<pre>
# CPU分析 (采样30秒)
go tool pprof http://localhost:8080/debug/pprof/profile?seconds=30

# 内存分析
go tool pprof http://localhost:8080/debug/pprof/heap

# Goroutine分析
go tool pprof http://localhost:8080/debug/pprof/goroutine

# 生成火焰图
go tool pprof -http=:8081 http://localhost:8080/debug/pprof/profile
				</pre>
			</div>
		</body>
		</html>
		`
		fmt.Fprintf(w, html, time.Now().Format("2006-01-02 15:04:05"), runtime.NumGoroutine())
	})
	
	// 启动服务器
	port := ":8080"
	log.Printf("服务器启动中，监听端口 %s", port)
	log.Printf("访问 http://localhost%s 查看演示页面", port)
	log.Printf("pprof 端点: http://localhost%s/debug/pprof/", port)
	
	if err := http.ListenAndServe(port, nil); err != nil {
		log.Fatal("服务器启动失败:", err)
	}
}
