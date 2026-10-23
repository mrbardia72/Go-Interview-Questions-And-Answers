<h2 dir="rtl"> 🌱 <code>context.Context</code> چه نقشی در Concurrency دارد؟</h2>

<p dir="rtl">
Context برای انتقال Cancellation، Deadline، Timeout و برخی Request-Scoped Values بین توابع و Goroutineها استفاده می‌شود.
</p>

```go
ctx, cancel := context.WithCancel(context.Background())
defer cancel()
```
<p dir="rtl">
Goroutine می‌تواند با بررسی <code>ctx.Done()</code> متوجه شود که باید اجرای خود را متوقف کند.
</p>

```go
select {
case &lt;-ctx.Done():
    return

case job := &lt;-jobs:
    process(job)
}
```
<p dir="rtl">
Context باعث Kill کردن مستقیم Goroutine نمی‌شود؛ بلکه یک سیگنال Cancellation فراهم می‌کند و Goroutine باید به‌صورت Cooperative به آن واکنش نشان دهد.
</p>

<h2 dir="rtl"> 🌱 تفاوت <code>close</code> و <code>cancel</code> چیست؟</h2>

<p dir="rtl">
<code>close(channel)</code> وضعیت یک Channel را تغییر می‌دهد و اعلام می‌کند که دیگر Send جدیدی از آن Channel انجام نخواهد شد.
</p>

<p dir="rtl">
اما <code>cancel()</code> مربوط به Context است و Cancellation را به Goroutineها و عملیات وابسته به آن Context اعلام می‌کند.
</p>

<p dir="rtl">
Close کردن Channel و Cancel کردن Context دو مفهوم متفاوت هستند و جایگزین مستقیم یکدیگر نیستند.
</p>

<p dir="rtl">
Context بیشتر برای مدیریت Lifecycle و Cancellation استفاده می‌شود، در حالی که Channel علاوه بر Synchronization می‌تواند برای انتقال Data نیز استفاده شود.
</p>

<h2 dir="rtl"> 🌱 چگونه یک Goroutine را Gracefully Shutdown کنیم؟</h2>

<p dir="rtl">
یکی از روش‌های استاندارد استفاده از Context است.
</p>

```go
ctx, cancel := context.WithCancel(context.Background())

go func() {
    for {
        select {
        case &lt;-ctx.Done():
            return

        case job := &lt;-jobs:
            process(job)
        }
    }
}()

cancel()</code></pre>
```
<p dir="rtl">
با فراخوانی <code>cancel</code> سیگنال توقف ارسال می‌شود و Goroutine در اولین فرصت مناسب از Loop خارج می‌شود.
</p>

<p dir="rtl">
در سیستم‌های Production معمولاً علاوه بر Cancellation باید منتظر پایان Goroutineها نیز بمانیم؛ بنابراین Context را می‌توان همراه با WaitGroup یا errgroup استفاده کرد.
</p>

<h2 dir="rtl"> 🌱 اگر یک Goroutine روی Channel گیر کند، چگونه آن را آزاد کنیم؟</h2>

<p dir="rtl">
اگر Goroutine روی یک Channel منتظر بماند و هیچ‌گاه مقدار مورد انتظار ارسال نشود، ممکن است دچار Goroutine Leak شود.
</p>

<p dir="rtl">
یک راه حل رایج استفاده از Context در کنار Channel است:
</p>

```go
select {
case result := &lt;-resultCh:
    process(result)

case &lt;-ctx.Done():
    return
}
```
<p dir="rtl">
در این حالت Goroutine فقط منتظر Result نیست و می‌تواند در صورت Cancellation نیز خارج شود.
</p>

<h2 dir="rtl"> 🌱 تفاوت <code>errgroup</code> و <code>sync.WaitGroup</code> چیست؟</h2>

<p dir="rtl">
WaitGroup صرفاً برای هماهنگ کردن پایان چند Goroutine استفاده می‌شود و خودش مکانیزم استانداردی برای انتقال Error ندارد.
</p>

<p dir="rtl">
<code>errgroup</code> برای اجرای چند Goroutine همراه با مدیریت Error و Cancellation طراحی شده است.
</p>

<p dir="rtl">
اگر چند عملیات همزمان انجام دهیم و یکی از آن‌ها با Error مواجه شود، errgroup می‌تواند Context مرتبط را Cancel کند تا عملیات‌های دیگر نیز متوقف شوند.
</p>

<h2 dir="rtl"> 🌱 اگر یکی از Goroutineها Error بدهد، چگونه بقیه Goroutineها را متوقف کنیم؟</h2>

<p dir="rtl">
راهکار رایج استفاده از Context Cancellation است.
</p>

```go
ctx, cancel := context.WithCancel(context.Background())
defer cancel()
```
<p dir="rtl">
Workerهای دیگر باید در عملیات‌های خود <code>ctx.Done()</code> را بررسی کنند تا بتوانند اجرای خود را متوقف کنند.
</p>

<p dir="rtl">
در چنین سناریویی <code>errgroup.WithContext</code> نیز گزینه مناسبی است، زیرا Error و Cancellation را با هم مدیریت می‌کند.
</p>

<h2 dir="rtl"> 🌱 چگونه یک برنامه Concurrent را Gracefully Shutdown کنیم؟</h2>

<p dir="rtl">
در یک برنامه Production معمولاً باید چند مرحله را مدیریت کنیم:
</p>

<ol dir="rtl">
<li>دریافت Signal مربوط به Shutdown</li>
<li>اعلام Cancellation به Goroutineها</li>
<li>جلوگیری از دریافت Job جدید</li>
<li>اتمام یا لغو Jobهای در حال اجرا</li>
<li>بستن Resourceها</li>
<li>منتظر ماندن برای پایان Goroutineها</li>
</ol>

<p dir="rtl">
Context، WaitGroup و Channelها می‌توانند در این فرآیند استفاده شوند.
</p>

<p dir="rtl">
هدف Graceful Shutdown این است که برنامه بدون رها کردن ناگهانی عملیات و بدون ایجاد Goroutine Leak یا Resource Leak متوقف شود.
</p>
