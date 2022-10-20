## 🌱 Q1: what is the difference between RLock() and Lock() in Golang and how they can be used efficiently when we use mutex Lock ?
* Lock(): only one go routine read/write at a time by acquiring the lock.
* RLock(): multiple go routine can read(not write) at a time by acquiring the lock.
```
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
```
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
## 🌱 Q2: What is the benefit of using RWMutex instead of Mutex?
*  RWMutex:
```
func (rw *RWMutex) Lock()
func (rw *RWMutex) Unlock()
func (rw *RWMutex) RLock()
func (rw *RWMutex) RUnlock()
```
*  Mutex:
```
func (m *Mutex) Lock()
func (m *Mutex) Unlock()
```

*  A RWMutex is a reader/writer mutual exclusion lock. The lock can be held by an arbitrary number of readers or a single writer. The zero value for a RWMutex is an unlocked mutex. In other words, readers don't have to wait for each other. They only have to wait for writers holding the lock. A sync.RWMutex is thus preferable for data that is mostly read, and the resource that is saved compared to a sync.Mutex is time.
#### why we need RWMutex?
 the problem is, that when using Mutex the value from the memory will be locked until the Unlock method will be invoked. This is also valable for the reading phase. In order to make reading accessible for multiple threads, the Mutex can be replaced with RWMutex, and for reading it will be used RLock and RUnlock methods.
## 🌱 Q3: Is there a difference in Go between a counter using atomic operations and one using a mutex?

#### That said, sticking to atomic.AddInt32 and atomic.LoadInt32 is safe as long as you are just reporting statistical information, and not actually relying on the values carrying any meaning about the state of the different goroutines.
####  When using the atomic counter, there are no syncronisation events (e.g. mutex lock/unlock, syscalls) which means that the goroutine never yields control. The result of this is that this goroutine starves the thread it is running on, and prevents the scheduler from allocating time to any other goroutines allocated to that thread, this includes ones that increment the counter meaning the counter never reaches 10000000.

## 🌱 Q4: five concurrency patterns in Golang

### 1. for-select pattern
#### This is a fundamental pattern. It is typically used to read data from multiple channels.The select statement looks like switch one, but its behavior is different. All cases are considered simultaneously & have equal chance to be selected. If none of the cases are ready to run, the entire select statement blocks.
```
var c1, c2 <-chan int

for { // Either loop infinitely or range over something 
    select {
    case <-c1: // Do some work with channels
    case <-c2:
    default: // auto run if other cases are not ready
    }

    // do some work
}
```
### 2. done channel pattern
#### Goroutine is not garbage collected; hence, it is likely to be leaked.
```go func() {
// <operation that will block forever>
// => Go routine leaks
}()
// Do work
```
#### To avoid leaking, Goroutine should be cancelled whenever it is told to do. A parent Goroutine needs to send cancellation signal to its child via a read-only channel named done . By convention, it is set as the 1st parameter.
#### This pattern is also utilized a lot in other patterns.
``` 
/child goroutine
doWork(<-done chan interface {}, other_params) <- terminated chan interface{} {
    terminated := make(chan interface{}) // to tell outer that it has finished
    defer close(terminated)

    for {
        select: {
            case: //do your work here
            case <- done:
                return
        }
        // do work here
    }

    return terminated
}

// parent goroutine
done := make(chan interface{})
terminated := doWork(done, other_args)

// do sth
// then tell child to stop
close (done)

// wait for child finish its work
<- terminated0
```
### 3. or-channel pattern
#### This pattern aims to combine multiple done channels into one agg_done; it means that if one of a done channel is signaled, the whole agg_done channel is also closed. Yet, we do not know number of done channels during runtime in advanced.
#### or-channel pattern can do so by using goroutine & recursion .
``` 
// return agg_done channel
var or func(channels ... <-chan interface{}) <- chan interface{} 

or = func(channels ...<-chan interface{}) <-chan interface{} {
    // base cases
    switch len(channels) { 
        case 0: return nil
        case 1: return channels[0]
    }

    orDone := make(chan interface{})

    go func() {
        defer close(orDone)

        switch len(channels) {
            case 2: 
                select {
                    case <- channels[0]:
                    case <- channels[1]:
                }
            default:
                select {
                    case <- channels[0]:
                    case <- channels[1]:
                    case <- channels[2]:
                    case <- or(append(channels[3:], orDone)...): // * line
                }

        }

    }
    return orDone
}

```
### 4. tee channel pattern
#### This pattern aims to split values coming from a channel into 2 others. So that we can dispatch them into two separate areas of our codebase.

### 5. bridge channel pattern
#### Reading values from channel of channels (<-chan <-chan interface{}) can be cumbersome. Hence, this pattern aims to merge all values into 1 channel, so that the consumer jobs is much easier.

## 🌱 Q5: What Is a Race Condition?
#### Race conditions are the outcomes of two different concurrent contexts reading and writing to the same shared data at the same time, resulting in an unexpected output. In Golang two concurrent goroutines that access the same variable concurrently will produce a data race in the program

## 🌱 Q6: How to Avoid Race Conditions in Golang?

#### The sync.Mutex package provides a mechanism to guard a block of code, making it concurrency-safe, meaning write operations within that block will be safe. The primitives that the sync package provides allow you to write concurrent code using memory access synchronization to avoid data race conditions.

#### This mechanism constitutes using the Lock and Unlock, methods from the package.

#### The Lock method will establish that the goroutine who calls this method has just acquired the lock and no other goroutines can use the lock until it is released.

#### The Unlock method releases the lock so that other goroutines can use it.

#### When one goroutine is using the lock and another one tries to acquire the lock too, the goroutine will block until the other goroutine releases the lock.