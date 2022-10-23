## what is the difference between RLock() and Lock() in Golang and how they can be used efficiently when we use mutex Lock ?
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

#### See following example for more clarification:
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
## What is the benefit of using RWMutex instead of Mutex?
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
## Is there any difference between "mutex" and "atomic operation"?
A mutex is a data structure that enables you to perform mutually exclusive actions. An atomic operation, on the other hand, is a single operation that is mutually exclusive, meaning no other thread can interfere with it.

Many programming languages provide classes with names like “lock” or “mutex” and a lock method. One thread then calls lock on an object of this class to acquire it and no other thread can acquire the lock unless the original thread has called release.

These are examples of mutexes but some authors use the term “mutex” in a more general way.

When you say that an operation is atomic, for example writing a variable, you mean that one thread writes the variable and no other thread can write it unless the first thread has finished.

To summarise, mutex usually refers to a datastructure or the general concept of mutual exclusion and atomic operation means that a single operation cannot be interfered with.
***********************************
An atomic operation is one that cannot be subdivided into smaller parts. As such, it will never be halfway done, so you can guarantee that it will always be observed in a consistent state. For example, modern hardware implements atomic compare-and-swap operations.

A mutex (short for mutual exclusion) excludes other processes or threads from executing the same section of code (the critical section). Basically, it ensures that at most one thread is executing a given section of code. A mutex is also called a lock.

Underneath the hood, locks must be implemented using hardware somehow, and the implementation must make use of the atomicity guarantees of the underlying hardware.

Most nontrivial operations cannot be made atomic, so you must either use a lock to block other threads from operating while the critical section executes, or else you must carefully design a lock-free algorithm that ensures that all the critical state-changing operations can be safely implemented using atomic operations.

This is a very deep subject, and there is a large body of literature on all these topics. The Wikipedia links I've given are a good starting point, but since you're taking a class on operating systems right now, it might be best for you to ask your professor to provide good resources for learning and understanding this stuff.
***********************************
#### for example
Mutex

A mutex is like the key to a bathroom at a small business. Only one person ever has the key, so if some other person comes along they'll likely have to wait. Here's the rubs:
* If someone walks off with the key, then the waiting person never stops waiting.
* Nothing can stop some other process from making its own door to the bathroom.

In the context of code, a mutex is mostly the key part, and the person is a process.

#### Atomic

Atomic means something that can't be split into smaller steps. In the natural world there is no CPU clock -- so everything we do could be smaller steps -- but let's pretend...

When you're typing on your keyboard, every key you hit is an atomic action. It happens all at once, and you can not hit two keys at exactly the same time. Here's what's good about this:
* No waiting: the fact that no two keys are being hit at the same time is not because one has to wait. It's because one is always done by the time the next gets there.
* No collision: no matter how much you hammer away, you'll never get two characters overlaid. One always happens before the other, completely.
  
For a counter example, if you were trying to type two words at the same time, that would be not atomic. The letters would mix up.

In the context of code, hitting keys is the same as running a single CPU command. It doesn't matter what other commands are in queue, the one your are doing will finish in its entirety before the next happens.

If you can do something atomically, then you don't have to worry about collision. But not everything is feasible within these bounds. Generally, atomics are for really low level operations -- like getting and setting an primitive (int, boolean, etc). For anything that's going to run a bunch of CPU commands but wants to be atomic, there's a couple tricks:

* Use a mutex. Kind of cheating, not really atomic. But some things do this and call themselves atomic.
* Carefully writing code such that it never requires more than one concurrent instruction on a piece of data in a row to remain correct. This one gets a bit deeper, but sometimes it can be done.
## five concurrency patterns in Golang

#### 1. for-select pattern
This is a fundamental pattern. It is typically used to read data from multiple channels.The select statement looks like switch one, but its behavior is different. All cases are considered simultaneously & have equal chance to be selected. If none of the cases are ready to run, the entire select statement blocks.
```go
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
#### 2. done channel pattern
Goroutine is not garbage collected; hence, it is likely to be leaked.
```go
go func() {
// <operation that will block forever>
// => Go routine leaks
}()
// Do work
```
To avoid leaking, Goroutine should be cancelled whenever it is told to do. A parent Goroutine needs to send cancellation signal to its child via a read-only channel named done . By convention, it is set as the 1st parameter.
This pattern is also utilized a lot in other patterns.
```go
//child goroutine
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
#### 3. or-channel pattern
This pattern aims to combine multiple done channels into one agg_done; it means that if one of a done channel is signaled, the whole agg_done channel is also closed. Yet, we do not know number of done channels during runtime in advanced.
or-channel pattern can do so by using goroutine & recursion .
```go
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
#### 4. tee channel pattern
This pattern aims to split values coming from a channel into 2 others. So that we can dispatch them into two separate areas of our codebase.

#### 5. bridge channel pattern
Reading values from channel of channels (<-chan <-chan interface{}) can be cumbersome. Hence, this pattern aims to merge all values into 1 channel, so that the consumer jobs is much easier.

##  What Is a Race Condition?
Race conditions are the outcomes of two different concurrent contexts reading and writing to the same shared data at the same time, resulting in an unexpected output. In Golang two concurrent goroutines that access the same variable concurrently will produce a data race in the program

##  How to Avoid Race Conditions in Golang?

The sync.Mutex package provides a mechanism to guard a block of code, making it concurrency-safe, meaning write operations within that block will be safe. The primitives that the sync package provides allow you to write concurrent code using memory access synchronization to avoid data race conditions.

This mechanism constitutes using the Lock and Unlock, methods from the package.

The Lock method will establish that the goroutine who calls this method has just acquired the lock and no other goroutines can use the lock until it is released.

The Unlock method releases the lock so that other goroutines can use it.

When one goroutine is using the lock and another one tries to acquire the lock too, the goroutine will block until the other goroutine releases the lock.

##  What exactly does runtime.Gosched do?
As of Go 1.5, GOMAXPROCS is set to the number of cores of the hardware:

When you run Go program without specifying GOMAXPROCS environment variable, Go goroutines are scheduled for execution in single OS thread. However, to make program appear to be multithreaded (that's what goroutines are for, aren't they?), the Go scheduler must sometimes switch the execution context, so each goroutine could do its piece of work.

As I said, when GOMAXPROCS variable is not specified, Go runtime is only allowed to use one thread, so it is impossible to switch execution contexts while goroutine is performing some conventional work, like computations or even IO (which is mapped to plain C functions). The context can be switched only when Go concurrency primitives are used, e.g. when you switch on several chans, or (this is your case) when you explicitly tell the scheduler to switch the contexts - this is what runtime.Gosched is for.

this is called 'cooperative multitasking': goroutines must explicitly yield the control to other goroutines. The approach used in most contemporary OSes is called 'preemptive multitasking': execution threads are not concerned with control transferring; the scheduler switches execution contexts transparently to them instead. Cooperative approach is frequently used to implement 'green threads', that is, logical concurrent coroutines which do not map 1:1 to OS threads - this is how Go runtime and its goroutines are implemented.

##  Why does the use of an unbuffered channel in the same goroutine result in a deadlock?
If the channel is unbuffered, the sender blocks until the receiver has received the value. If the channel has a buffer, the sender blocks only until the value has been copied to the buffer; if the buffer is full, this means waiting until some receiver has retrieved a value.

#### Said otherwise :

* when a channel is full, the sender waits for another goroutine to make some room by receiving
* you can see an unbuffered channel as an always full one : there must be another goroutine to take what the sender sends.


