# Golang Roadmap – مسیر کامل یادگیری Go
بر اساس https://roadmap.sh/golang

---

## مقدمه

این README یک راهنمای گام‌به‌گام برای یادگیری زبان Go است که دقیقاً مطابق نقشه راه رسمی roadmap.sh نوشته شده است.  
در هر بخش:
- توضیح می‌دهیم این قسمت چیست
- می‌گوییم از **کدام لینک رسمی** یادگیری را شروع کنید

---

## فهرست مطالب

1. [Introduction to Go](#introduction-to-go)
2. [Language Basics](#language-basics)
3. [Data Types](#data-types)
4. [Composite Types](#composite-types)
5. [Structs](#structs)
6. [Control Flow](#control-flow)
7. [Functions](#functions)
8. [Pointers](#pointers)
9. [Methods & Interfaces](#methods--interfaces)
10. [Generics](#generics)
11. [Code Organization](#code-organization)
12. [Error Handling](#error-handling)
13. [Concurrency](#concurrency)
14. [Context](#context)
15. [Testing & Benchmarking](#testing--benchmarking)
16. [Standard Library](#standard-library)
17. [Ecosystem & Libraries](#ecosystem--libraries)
18. [Web Development & gRPC](#web-development--grpc)
19. [Tooling & Performance](#tooling--performance)
20. [Advanced Topics](#advanced-topics)

---

## Introduction to Go

### توضیح
آشنایی با فلسفه Go، دلیل ساخته‌شدن آن، تاریخچه و مزایا (سادگی، سرعت، concurrency).

### شروع یادگیری از:
- https://go.dev/doc
- https://en.wikipedia.org/wiki/Go_(programming_language)

---

## Language Basics

### شامل
- Variables (`var`, `:=`)
- Zero Values
- Constants (`const`, `iota`)
- Scope & Shadowing

### شروع یادگیری از:
- https://go.dev/tour/basics/1
- https://gobyexample.com/variables

---

## Data Types

### شامل
- Integers (signed/unsigned)
- Floating point
- Complex numbers
- Boolean
- Rune
- String
- Type Conversion
- Comma-ok idiom

### شروع یادگیری از:
- https://go.dev/tour/basics/11
- https://gobyexample.com/values

---

## Composite Types

### شامل
- Arrays
- Slices (make, len, cap)
- Slice growth
- Maps
- Array ↔ Slice conversion

### شروع یادگیری از:
- https://gobyexample.com/slices
- https://gobyexample.com/maps

---

## Structs

### شامل
- Struct basics
- Struct tags (JSON)
- Embedding structs
- Struct to JSON

### شروع یادگیری از:
- https://gobyexample.com/structs
- https://pkg.go.dev/encoding/json

---

## Control Flow

### شامل
- for
- range
- if / else
- switch
- break / continue
- Iterating maps & strings

### شروع یادگیری از:
- https://gobyexample.com/for
- https://gobyexample.com/switch

---

## Functions

### شامل
- Function basics
- Multiple return values
- Anonymous functions
- Closures
- Named return values
- Call by value

### شروع یادگیری از:
- https://gobyexample.com/functions

---

## Pointers

### شامل
- Pointer basics
- Pointers with structs
- Pointers with maps & slices
- Memory overview
- Garbage Collection

### شروع یادگیری از:
- https://gobyexample.com/pointers
- https://go.dev/doc/faq#Pointers

---

## Methods & Interfaces

### Methods
- Methods vs functions
- Pointer receivers
- Value receivers

### Interfaces
- Interface basics
- Empty interface
- Embedding interfaces
- Type assertions
- Type switch

### شروع یادگیری از:
- https://gobyexample.com/methods
- https://gobyexample.com/interfaces

---

## Generics

### شامل
- Why generics
- Generic functions
- Generic types
- Type constraints
- Type inference

### شروع یادگیری از:
- https://go.dev/doc/tutorial/generics

---

## Code Organization

### شامل
- Packages
- Import rules
- Modules
- go mod init
- go mod tidy
- Publishing modules

### شروع یادگیری از:
- https://go.dev/doc/modules

---

## Error Handling

### شامل
- error interface
- errors.New
- fmt.Errorf
- Wrapping / Unwrapping
- Sentinel errors
- panic & recover

### شروع یادگیری از:
- https://go.dev/blog/error-handling-and-go
- https://go.dev/doc/tutorial/error-handling

---

## Concurrency

### شامل
- Goroutines
- Channels
- Buffered / Unbuffered
- Select
- Worker pools
- sync package
- Mutex
- WaitGroup
- Race detection

### شروع یادگیری از:
- https://gobyexample.com/concurrency
- https://go.dev/doc/effective_go#concurrency

---

## Context

### شامل
- Deadlines
- Cancellation
- Context propagation
- Common use cases

### شروع یادگیری از:
- https://pkg.go.dev/context

---

## Testing & Benchmarking

### شامل
- testing package
- Table-driven tests
- Mocks & stubs
- HTTP testing
- Benchmarks
- Coverage

### شروع یادگیری از:
- https://go.dev/doc/tutorial/add-a-test
- https://gobyexample.com/testing-and-benchmarking

---

## Standard Library

### بخش‌های مهم
- I/O & File handling
- time
- encoding/json
- os
- regexp
- log / slog
- embed

### شروع یادگیری از:
- https://pkg.go.dev/std

---

## Ecosystem & Libraries

### CLI
- cobra
- urfave/cli
- bubbletea

### Logging
- zap
- zerolog

### ORM & DB
- GORM
- sqlx
- pgx

### شروع یادگیری از:
- https://github.com/spf13/cobra
- https://gorm.io

---

## Web Development & gRPC

### Web
- net/http
- Frameworks (optional)
  - gin
  - echo
  - fiber
  - beego

### gRPC
- Protocol Buffers
- gRPC services

### شروع یادگیری از:
- https://go.dev/doc/articles/wiki/
- https://grpc.io/docs/languages/go/

---

## Tooling & Performance

### شامل
- go build
- go test
- go fmt
- go vet
- golangci-lint
- pprof
- trace
- race detector
- go generate
- build tags
- cross compilation

### شروع یادگیری از:
- https://go.dev/doc/tools
- https://go.dev/blog/pprof

---

## Advanced Topics

### شامل
- Memory management in depth
- Escape analysis
- Reflection
- unsafe package
- Build constraints
- CGO basics
- Compiler & linker flags
- Plugins & dynamic loading

### شروع یادگیری از:
- https://pkg.go.dev/reflect
- https://pkg.go.dev/unsafe

---

## جمع‌بندی مسیر پیشنهادی

1. Basics + Data Types  
2. Composite Types + Structs  
3. Functions + Pointers  
4. Interfaces + Generics  
5. Concurrency + Context  
6. Modules + Error Handling  
7. Testing + Tooling  
8. Web / gRPC  
9. Advanced Topics  

---

## منبع اصلی

- https://roadmap.sh/golang
- https://go.dev
- https://pkg.go.dev
