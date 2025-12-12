package main

import (
    "bytes"
    "fmt"
    "os"
    "math/rand"
    "runtime/pprof"
    "runtime"
)

const Letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

func generate(n int) string {
    var buf bytes.Buffer
    for i := 0; i < n; i++ {
        buf.WriteByte(Letters[rand.Intn(len(Letters))])
    }
    return buf.String()
}

func repeat(s string, n int) string {
    var buf bytes.Buffer
    for i := 0; i < n; i++ {
        buf.WriteString(s)
    }
    return buf.String()
}

func main() {
    // 强制进行垃圾回收，获得基线
    runtime.GC()
    
    // 保存结果，防止被GC
    var results []string
    
    for i := 0; i < 100; i++ {
        // 保存结果
        results = append(results, repeat(generate(100), 100))
        
        // 每10次手动触发GC，观察内存变化
        if i%10 == 0 {
            runtime.GC()
        }
    }
    
    // 在内存使用峰值时采集profile
    f, _ := os.OpenFile("mem.profile", os.O_CREATE|os.O_RDWR, 0644)
    defer f.Close()
    
    // 使用更详细的调试级别
    pprof.WriteHeapProfile(f)
    
    fmt.Println("Results count:", len(results))
    fmt.Println("Total length:", len(results[0])*len(results))
}
