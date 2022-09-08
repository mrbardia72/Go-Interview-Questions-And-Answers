## 🌱 what is the difference between RLock() and Lock() in Golang and how they can be used efficiently when we use mutex Lock ?
* Lock(): only one go routine read/write at a time by acquiring the lock.
* RLock(): multiple go routine can read(not write) at a time by acquiring the lock.
```go
package main

import (
	"fmt"
    "sync"
    "time"
)

func main() {

    a := 0

    lock := sync.RWMutex{}

    for i := 1; i < 10; i++ {
        go func(i int) {
            lock.Lock()
            fmt.Printf("Lock: from go routine %d: a = %d\n",i, a)
            time.Sleep(time.Second)
            lock.Unlock()
        }(i)
    }

    b := 0

    for i := 11; i < 20; i++ {
        go func(i int) {
            lock.RLock()
            fmt.Printf("RLock: from go routine %d: b = %d\n",i, b)
            time.Sleep(time.Second)
            lock.RUnlock()
        }(i)
    }

    <-time.After(time.Second*10)
}
```
1) When a go-routine has already acquired a RLock(), can another go-routine acquire a Lock() for write or it has to wait until RUnlock() happens?
* To acquire a Lock() for write it has to wait until RUnlock()

2) What happens when someone already acquired Lock() for map ,will other go-routine can still get RLock()
* if someone X already acquired Lock(), then other go-routine to get RLock() will have to wait until X release lock (Unlock())

3) Assuming we are dealing with Maps here, is there any possibility of "concurrent read/write of Map" error can come?
* Map is not thread safe. so "concurrent read/write of Map" can cause error.

### See following example for more clarification:
```go
package main

import (
    "fmt"
    "sync"
    "time"
)

func main() {
    lock := sync.RWMutex{}

    b := map[string]int{}
    b["0"] = 0

    go func(i int) {
        lock.RLock()
        fmt.Printf("RLock: from go routine %d: b = %d\n",i, b["0"])
        time.Sleep(time.Second*3)
        fmt.Printf("RLock: from go routine %d: lock released\n",i)
        lock.RUnlock()
    }(1)

    go func(i int) {
        lock.Lock()
        b["2"] = i
        fmt.Printf("Lock: from go routine %d: b = %d\n",i, b["2"])
        time.Sleep(time.Second*3)
        fmt.Printf("Lock: from go routine %d: lock released\n",i)
        lock.Unlock()
    }(2)

    <-time.After(time.Second*8)

    fmt.Println("*************************************8")

    go func(i int) {
        lock.Lock()
        b["3"] = i
        fmt.Printf("Lock: from go routine %d: b = %d\n",i, b["3"])
        time.Sleep(time.Second*3)
        fmt.Printf("Lock: from go routine %d: lock released\n",i)
        lock.Unlock()
    }(3)

    go func(i int) {
        lock.RLock()
        fmt.Printf("RLock: from go routine %d: b = %d\n",i, b["3"])
        time.Sleep(time.Second*3)
        fmt.Printf("RLock: from go routine %d: lock released\n",i)
        lock.RUnlock()
    }(4)

    <-time.After(time.Second*8)
}
```
## 🌱 What is the benefit of using RWMutex instead of Mutex?
#### I am not sure when to use RWMutex and when to use Mutex.
#### Do you save resources if you use RWMutex instead of Mutex if you do more reads then writes?
#### I see some people use Mutex all the time no matter what they do, and some use RWMutex and run these methods:
```go
func (rw *RWMutex) Lock()
func (rw *RWMutex) Unlock()
func (rw *RWMutex) RLock()
func (rw *RWMutex) RUnlock()
```
#### instead of just:
```go
func (m *Mutex) Lock()
func (m *Mutex) Unlock()
```
[From the docs](https://golang.org/pkg/sync/#RWMutex)
#### A RWMutex is a reader/writer mutual exclusion lock. The lock can be held by an arbitrary number of readers or a single writer. The zero value for a RWMutex is an unlocked mutex. In other words, readers don't have to wait for each other. They only have to wait for writers holding the lock. A sync.RWMutex is thus preferable for data that is mostly read, and the resource that is saved compared to a sync.Mutex is time.

## 🌱 Is there a difference in Go between a counter using atomic operations and one using a mutex?

#### That said, sticking to atomic.AddInt32 and atomic.LoadInt32 is safe as long as you are just reporting statistical information, and not actually relying on the values carrying any meaning about the state of the different goroutines.
####  When using the atomic counter, there are no syncronisation events (e.g. mutex lock/unlock, syscalls) which means that the goroutine never yields control. The result of this is that this goroutine starves the thread it is running on, and prevents the scheduler from allocating time to any other goroutines allocated to that thread, this includes ones that increment the counter meaning the counter never reaches 10000000.





