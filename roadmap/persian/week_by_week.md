# Golang Roadmap – برنامه هفتگی (Week-by-Week)
بر اساس https://roadmap.sh/golang

---

## 🎯 هدف برنامه
رساندن شما از **سطح مبتدی/متوسط** به **توسعه‌دهنده حرفه‌ای Go** با تمرکز بر:
- Core Language
- Concurrency
- Backend & Production
- Performance & Tooling

⏱ مدت کل: **18 تا 20 هفته**

---

## Week 1 – آشنایی و محیط توسعه

### موضوعات
- Why Go
- History of Go
- نصب Go
- Hello World
- go command (run, build)

### منابع شروع
- https://go.dev/doc/install
- https://go.dev/tour/welcome/1

### خروجی هفته
- نصب Go
- اجرای چند برنامه ساده با `go run`
- آشنایی با ساختار پروژه Go

---

## Week 2 – Language Basics

### موضوعات
- Variables (`var`, `:=`)
- Zero Values
- Constants (`const`, `iota`)
- Scope & Shadowing

### منابع
- https://go.dev/tour/basics/1
- https://gobyexample.com/variables

### خروجی
- نوشتن برنامه‌های ساده با متغیر و ثابت
- درک scope و خطاهای رایج

---

## Week 3 – Data Types

### موضوعات
- Numeric types
- Boolean
- Rune
- String
- Type conversion
- Comma-ok idiom

### منابع
- https://go.dev/tour/basics/11
- https://gobyexample.com/values

### خروجی
- برنامه‌ای که با انواع داده مختلف کار کند
- تمرین map lookup با comma-ok

---

## Week 4 – Composite Types

### موضوعات
- Arrays
- Slices (make, len, cap)
- Slice growth
- Maps
- Slice ↔ Array conversion

### منابع
- https://gobyexample.com/slices
- https://gobyexample.com/maps

### خروجی
- پیاده‌سازی لیست داده با slice
- استفاده عملی از map

---

## Week 5 – Structs و JSON

### موضوعات
- Struct basics
- Struct tags
- JSON marshal/unmarshal
- Embedding structs

### منابع
- https://gobyexample.com/structs
- https://pkg.go.dev/encoding/json

### خروجی
- مدل‌سازی داده (User, Product)
- تبدیل Struct ↔ JSON

---

## Week 6 – Control Flow

### موضوعات
- for
- range
- if / else
- switch
- break / continue

### منابع
- https://gobyexample.com/for
- https://gobyexample.com/switch

### خروجی
- برنامه پردازش داده با loop و condition

---

## Week 7 – Functions

### موضوعات
- Function basics
- Multiple return values
- Anonymous functions
- Closures
- Named returns

### منابع
- https://gobyexample.com/functions

### خروجی
- توابع reusable
- تمرین closure ساده

---

## Week 8 – Pointers و Memory Overview

### موضوعات
- Pointer basics
- Pointer with struct
- Pointer with slice & map
- Memory basics
- Garbage Collection

### منابع
- https://gobyexample.com/pointers
- https://go.dev/doc/faq#Pointers

### خروجی
- درک تفاوت value vs pointer
- اصلاح کدهای inefficient

---

## Week 9 – Methods

### موضوعات
- Methods vs functions
- Pointer receivers
- Value receivers

### منابع
- https://gobyexample.com/methods

### خروجی
- اضافه کردن method به structها

---

## Week 10 – Interfaces

### موضوعات
- Interface basics
- Empty interface
- Embedding interfaces
- Type assertion
- Type switch

### منابع
- https://gobyexample.com/interfaces

### خروجی
- طراحی interface برای abstraction

---

## Week 11 – Generics

### موضوعات
- Why generics
- Generic functions
- Generic types
- Type constraints
- Type inference

### منابع
- https://go.dev/doc/tutorial/generics

### خروجی
- بازنویسی توابع تکراری با generics

---

## Week 12 – Code Organization & Modules

### موضوعات
- Packages
- Import rules
- Go modules
- go mod init / tidy
- Publishing modules

### منابع
- https://go.dev/doc/modules

### خروجی
- ساخت پروژه ماژولار

---

## Week 13 – Error Handling

### موضوعات
- error interface
- errors.New
- fmt.Errorf
- Wrapping / unwrapping
- Sentinel errors
- panic / recover

### منابع
- https://go.dev/blog/error-handling-and-go

### خروجی
- طراحی error strategy برای پروژه

---

## Week 14 – Concurrency Basics

### موضوعات
- Goroutines
- Channels
- Buffered / Unbuffered
- Select

### منابع
- https://gobyexample.com/concurrency

### خروجی
- برنامه concurrent ساده

---

## Week 15 – Concurrency Advanced

### موضوعات
- Worker pools
- sync package
- Mutex
- WaitGroup
- Race detection

### منابع
- https://pkg.go.dev/sync

### خروجی
- حل race condition
- اجرای race detector

---

## Week 16 – Context

### موضوعات
- Context cancellation
- Deadlines
- Context propagation

### منابع
- https://pkg.go.dev/context

### خروجی
- استفاده از context در goroutineها

---

## Week 17 – Testing & Benchmarking

### موضوعات
- testing package
- Table-driven tests
- HTTP tests
- Benchmarks
- Coverage

### منابع
- https://go.dev/doc/tutorial/add-a-test

### خروجی
- تست کامل پروژه قبلی

---

## Week 18 – Standard Library & Ecosystem

### موضوعات
- time
- os
- io
- regexp
- log / slog
- embed
- popular libraries

### منابع
- https://pkg.go.dev/std

### خروجی
- استفاده عملی از stdlib

---

## Week 19 – Web Development & gRPC

### موضوعات
- net/http
- REST API
- Gin / Echo (اختیاری)
- gRPC & Protobuf

### منابع
- https://go.dev/doc/articles/wiki/
- https://grpc.io/docs/languages/go/

### خروجی
- API ساده یا gRPC service

---

## Week 20 – Tooling, Performance & Advanced Topics

### موضوعات
- go fmt / vet / lint
- pprof
- trace
- race detector
- Escape analysis
- Reflection
- unsafe (در حد آشنایی)

### منابع
- https://go.dev/doc/tools
- https://go.dev/blog/pprof

### خروجی نهایی 🎯
- یک پروژه Production-ready
- تست + benchmark + profiling

---

## 🧭 جمع‌بندی

اگر این برنامه را کامل اجرا کنید:
- Core Go را عمیق بلدید
- Concurrency را درست استفاده می‌کنید
- آماده کار روی پروژه‌های واقعی Backend هستید

---

## منبع اصلی
- https://roadmap.sh/golang
