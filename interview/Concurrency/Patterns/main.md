<h2 dir="rtl"> 🌱 Worker Pool چیست و چگونه در Go پیاده‌سازی می‌شود؟</h2>

<p dir="rtl">
Worker Pool الگویی است که در آن تعداد مشخصی Worker ایجاد می‌کنیم و مجموعه‌ای از Jobها بین آن‌ها توزیع می‌شود.
</p>

```go
Jobs
  |
  +---- Worker 1
  +---- Worker 2
  +---- Worker 3
  +---- Worker 4
  ```
<p dir="rtl">
به جای اینکه برای هر Job یک Goroutine جدید ایجاد کنیم، تعداد محدودی Worker ایجاد می‌کنیم. این کار می‌تواند تعداد عملیات همزمان و مصرف منابع را کنترل کند.
</p>

<p dir="rtl">
تعداد Workerها باید بر اساس نوع Workload، CPU، I/O، محدودیت منابع و Benchmark تعیین شود.
</p>

<h2 dir="rtl"> 🌱 Fan-out و Fan-in چیستند؟</h2>

<p dir="rtl">
Fan-out یعنی تقسیم کار بین چند Worker یا Goroutine برای پردازش یک جریان از Jobها.
</p>

<p dir="rtl">
Fan-in یعنی ترکیب چند جریان خروجی در یک جریان مشترک.
</p>

```go
Input
  |
  +---- Worker 1 ---+
  +---- Worker 2 ---+---- Output
  +---- Worker 3 ---+
```
<p dir="rtl">
این الگوها برای ساخت سیستم‌های Concurrent مانند Worker Pool و Pipeline بسیار کاربردی هستند.
</p>

<h2 dir="rtl"> 🌱 Pipeline در Go چیست؟</h2>

<p dir="rtl">
Pipeline یعنی پردازش داده در چند مرحله که خروجی هر مرحله ورودی مرحله بعدی است.
</p>


```go
Generate
   |
   v
Transform
   |
   v
Filter
   |
   v
Store
```
<p dir="rtl">
هر مرحله می‌تواند در یک یا چند Goroutine اجرا شود و Channelها ارتباط بین مراحل را برقرار کنند.
</p>

<p dir="rtl">
در طراحی Pipeline باید به Cancellation، Error Handling، Channel Ownership و جلوگیری از Goroutine Leak توجه کرد.
</p>

<h2 dir="rtl"> 🌱 Backpressure چیست و چگونه در Go پیاده‌سازی می‌شود؟</h2>

<p dir="rtl">
Backpressure زمانی اهمیت پیدا می‌کند که Producer سریع‌تر از Consumer داده تولید کند.
</p>


```go
Producer
   |
   v
Buffered Channel
   |
   v
Consumer
```
<p dir="rtl">
اگر Buffer محدود باشد، وقتی Buffer پر شود Producer نیز Block می‌شود. این رفتار باعث می‌شود سرعت تولید به ظرفیت پردازش سیستم وابسته شود.
</p>

<p dir="rtl">
Backpressure می‌تواند با Buffered Channel، Worker Pool، Semaphore، Queue با ظرفیت مشخص یا Rate Limiting طراحی شود.
</p>

<h2 dir="rtl"> 🌱 چگونه با Channel یک Rate Limiter ایجاد کنیم؟</h2>

<p dir="rtl">
یکی از روش‌ها استفاده از Ticker و Channel است.
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
Rate Limiting تعداد عملیات در واحد زمان را کنترل می‌کند.
</p>

<p dir="rtl">
Rate Limiting با Concurrency Limiting یکسان نیست. Concurrency Limiting تعداد عملیات همزمان را محدود می‌کند، در حالی که Rate Limiting نرخ انجام عملیات را کنترل می‌کند.
</p>

<h2 dir="rtl"> 🌱 اگر 10000 Task داشته باشیم ولی فقط اجازه اجرای همزمان 10 Task را داشته باشیم، چه می‌کنیم؟</h2>

<p dir="rtl">
یک روش مناسب استفاده از Worker Pool با 10 Worker است.
</p>


```go
jobs := make(chan Job)

for i := 0; i &lt; 10; i++ {
    go worker(jobs)
}
```
<p dir="rtl">
راهکار دیگر استفاده از Semaphore است.
</p>


```go
sem := make(chan struct{}, 10)

sem &lt;- struct{}{}

go func() {
    defer func() {
        &lt;-sem
    }()

    process()
}()
```
<p dir="rtl">
در این روش Channel ظرفیت 10 دارد و در نتیجه حداکثر 10 عملیات می‌توانند همزمان Token داشته باشند.
</p>

<h2 dir="rtl"> 🌱 چرا نباید برای هر Task بدون محدودیت یک Goroutine ایجاد کنیم؟</h2>

<p dir="rtl">
Goroutine سبک‌وزن است، اما رایگان نیست. هر Goroutine Memory و Runtime Metadata مصرف می‌کند و تعداد بسیار زیاد Goroutineها می‌تواند باعث فشار روی Memory و Scheduler شود.
</p>

<p dir="rtl">
اگر Taskها به Resource محدودی مانند Database Connection، CPU یا External API دسترسی داشته باشند، ایجاد Goroutine نامحدود می‌تواند باعث فشار بیش از حد روی آن Resource شود.
</p>

<p dir="rtl">
برای کنترل این شرایط می‌توان از Worker Pool، Semaphore، Queue با ظرفیت مشخص، Rate Limiting و Backpressure استفاده کرد.
</p>

<h2 dir="rtl"> 🌱 Concurrency Limiting و Rate Limiting چه تفاوتی دارند؟</h2>

<p dir="rtl">
Concurrency Limiting تعداد عملیات همزمان را محدود می‌کند.
</p>

<p dir="rtl">
مثلاً می‌گوییم حداکثر 10 Request همزمان پردازش شود.
</p>

<p dir="rtl">
Rate Limiting تعداد عملیات در واحد زمان را محدود می‌کند.
</p>

<p dir="rtl">
مثلاً می‌گوییم حداکثر 100 Request در یک ثانیه ارسال شود.
</p>

<p dir="rtl">
یک سیستم Production ممکن است به هر دو مکانیزم نیاز داشته باشد.
</p>
