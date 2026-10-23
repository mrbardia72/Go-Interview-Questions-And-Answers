<h2 dir="rtl"> 🌱 این کد چه مشکلی دارد؟</h2>

```go
var counter int

for i := 0; i &lt; 100; i++ {
    go func() {
        counter++
    }()
}
```
<p dir="rtl">
دو مشکل اصلی وجود دارد: Data Race روی <code>counter</code> و عدم انتظار برای پایان Goroutineها.
</p>

<p dir="rtl">
برای حل Race می‌توان از Mutex یا Atomic استفاده کرد و برای انتظار پایان Goroutineها می‌توان از WaitGroup استفاده کرد.
</p>


<h2 dir="rtl"> 🌱 چرا این کد Deadlock می‌شود؟</h2>

```go
func main() {
    ch := make(chan int)

    ch &lt;- 10

    fmt.Println(&lt;-ch)
}
```
<p dir="rtl">
چون Channel از نوع Unbuffered است، Send نیاز به Receiver دارد. Main Goroutine قبل از رسیدن به Receive روی Send Block می‌شود.
</p>

<h2 dir="rtl"> 🌱 خروجی این برنامه چیست؟</h2>

```go
func main() {
    ch := make(chan int)

    go func() {
        ch &lt;- 10
    }()

    fmt.Println(&lt;-ch)
}
```
<p dir="rtl">
خروجی برنامه <code>10</code> است.
</p>

<p dir="rtl">
Goroutine دوم مقدار 10 را روی Channel ارسال می‌کند و Main Goroutine روی Receive منتظر دریافت آن مقدار می‌ماند.
</p>

<p dir="rtl">
اگر Goroutine دوم حذف شود، Main روی Receive Block می‌شود و برنامه Deadlock خواهد شد.
</p>

<h2 dir="rtl"> 🌱 این Worker چه مشکلی دارد؟</h2>

```go
func worker(ch chan int) {
    for {
        value := &lt;-ch
        fmt.Println(value)
    }
}
```
<p dir="rtl">
Worker هیچ مکانیزمی برای پایان ندارد و ممکن است برای همیشه روی Receive Block شود.
</p>

<p dir="rtl">
می‌توان از <code>range</code> روی Channel استفاده کرد و Channel را در زمان مناسب Close کرد، یا از Context برای Cancellation استفاده کرد.
</p>

<h2 dir="rtl"> 🌱 یک Worker Pool با Go پیاده‌سازی کنید.</h2>

<p dir="rtl">
فرض کنید 100 Job داریم و می‌خواهیم حداکثر 5 Worker به‌صورت همزمان آن‌ها را پردازش کنند.
</p>

```go
jobs := make(chan Job)

for i := 0; i &lt; 5; i++ {
    go worker(jobs)
}

for _, job := range jobsList {
    jobs &lt;- job
}

close(jobs)
```
<p dir="rtl">
Workerها باید Jobها را از Channel دریافت کنند و پس از بسته شدن Channel و تمام شدن Jobهای موجود، خارج شوند.
</p>

<p dir="rtl">
در پیاده‌سازی Production باید WaitGroup، Context و Error Handling نیز در نظر گرفته شوند.
</p>

<h2 dir="rtl"> 🌱 یک Fan-in پیاده‌سازی کنید.</h2>

<p dir="rtl">
دو Channel ورودی مانند <code>ch1</code> و <code>ch2</code> را دریافت کنید و خروجی آن‌ها را در یک Channel به نام <code>merged</code> قرار دهید.
</p>

```go
func merge(ch1, ch2 &lt;-chan int) &lt;-chan int {
    out := make(chan int)

    go func() {
        defer close(out)

        for ch1 != nil || ch2 != nil {
            select {
            case v, ok := &lt;-ch1:
                if !ok {
                    ch1 = nil
                    continue
                }
                out &lt;- v

            case v, ok := &lt;-ch2:
                if !ok {
                    ch2 = nil
                    continue
                }
                out &lt;- v
            }
        }
    }()

    return out
}
```
<p dir="rtl">
نکته مهم این است که پس از بسته شدن هر Channel آن را <code>nil</code> کنیم تا Case مربوط به آن در Select غیرفعال شود.
</p>

<h2 dir="rtl"> 🌱 یک Pipeline سه مرحله‌ای پیاده‌سازی کنید.</h2>

<p dir="rtl">
Pipeline باید شامل سه مرحله باشد:
</p>

```go
Generate
   ↓
Square
   ↓
Print
```
<p dir="rtl">
هر مرحله باید Channel ورودی و خروجی داشته باشد.
</p>

<p dir="rtl">
در طراحی صحیح باید Channel خروجی هر مرحله در زمان مناسب Close شود و در صورت Cancellation نیز تمام Goroutineها بتوانند خارج شوند.
</p>

<h2 dir="rtl"> 🌱 یک Rate Limiter برای محدود کردن درخواست‌ها پیاده‌سازی کنید.</h2>

<p dir="rtl">
فرض کنید حداکثر 10 عملیات در هر ثانیه مجاز است.
</p>

<p dir="rtl">
می‌توان از Ticker استفاده کرد:
</p>

```go
ticker := time.NewTicker(time.Second / 10)
defer ticker.Stop()

for _, job := range jobs {
    &lt;-ticker.C
    process(job)
}
```
<p dir="rtl">
در سیستم واقعی باید مشخص کنیم Rate Limit دقیقاً بر اساس چه Window یا Algorithmی اعمال می‌شود.
</p>

<h2 dir="rtl"> 🌱 تعداد Goroutineهای همزمان را به 10 محدود کنید.</h2>

<p dir="rtl">
یکی از راهکارها استفاده از Semaphore مبتنی بر Buffered Channel است.
</p>

```go
sem := make(chan struct{}, 10)

for _, task := range tasks {
    sem &lt;- struct{}{}

    go func(task Task) {
        defer func() {
            &lt;-sem
        }()

        process(task)
    }(task)
}
```
<p dir="rtl">
ظرفیت Channel برابر 10 است؛ بنابراین حداکثر 10 Goroutine می‌توانند همزمان Token داشته باشند.
</p>

<h2 dir="rtl"> 🌱 این برنامه Goroutine Leak دارد یا خیر؟</h2>

```go
func worker(ch &lt;-chan int) {
    for {
        value := &lt;-ch
        process(value)
    }
}
```
<p dir="rtl">
اگر هیچ مکانیزمی برای بستن Channel یا Cancellation وجود نداشته باشد، Worker ممکن است برای همیشه روی Receive Block شود.
</p>

<p dir="rtl">
باید مشخص کنیم چه زمانی Worker باید متوقف شود و از Channel Close یا Context Cancellation استفاده کنیم.
</p>

<h2 dir="rtl"> 🌱 این برنامه Race Condition دارد یا خیر؟</h2>

```go
var balance int

go func() {
    balance += 100
}()

go func() {
    balance -= 50
}()
```
<p dir="rtl">
بله، چند Goroutine به State مشترک دسترسی دارند و حداقل یکی از عملیات‌ها Write است.
</p>

<p dir="rtl">
باید با Mutex، Atomic مناسب یا طراحی مبتنی بر Message Passing دسترسی به State را Synchronize کنیم.
</p>

<h2 dir="rtl"> 🌱 این برنامه چگونه Gracefully Shutdown شود؟</h2>

<p dir="rtl">
برنامه‌ای داریم که چند Worker دائماً Job دریافت می‌کنند. هنگام Shutdown باید Workerها به‌صورت کنترل‌شده متوقف شوند.
</p>

<p dir="rtl">
راهکار مناسب استفاده از Context Cancellation به همراه WaitGroup یا errgroup است.
</p>

```go
ctx, cancel := context.WithCancel(context.Background())
defer cancel()
```
<p dir="rtl">
Workerها باید <code>ctx.Done()</code> را بررسی کنند و پس از Cancellation خارج شوند.
</p>

<h2 dir="rtl"> 🌱 چگونه یک Concurrent System را از نظر Performance بررسی می‌کنید؟</h2>

<p dir="rtl">
ابتدا باید Bottleneck واقعی را پیدا کنیم و بدون اندازه‌گیری تعداد Goroutineها یا Lockها را تغییر ندهیم.
</p>

<p dir="rtl">
ابزارهای مهم شامل Benchmark، CPU Profile، Memory Profile، Goroutine Profile، Mutex Profile، Block Profile و Go Trace هستند.
</p>

<pre dir="ltr"><code>go test -bench=. -benchmem</code></pre>

<p dir="rtl">
در برنامه‌های Concurrent باید مواردی مانند Lock Contention، Channel Blocking، تعداد Goroutineها، Allocation و CPU Utilization بررسی شوند.
</p>

<h2 dir="rtl"> 🌱 یک سیستم طراحی کنید که اگر یکی از Workerها Error داد، تمام Workerهای دیگر متوقف شوند.</h2>

<p dir="rtl">
برای این مسئله باید Error Propagation و Cancellation را با هم مدیریت کنیم.
</p>

<p dir="rtl">
راهکار رایج استفاده از <code>errgroup.WithContext</code> است.
</p>

<p dir="rtl">
هر Worker در صورت Error آن را برمی‌گرداند و Context مرتبط Cancel می‌شود. Workerهای دیگر باید در عملیات خود <code>ctx.Done()</code> را بررسی کنند.
</p>