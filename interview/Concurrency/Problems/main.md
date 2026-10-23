<h2 dir="rtl"> 🌱 Deadlock چیست و چگونه در Go اتفاق می‌افتد؟</h2>

<p dir="rtl">
Deadlock زمانی رخ می‌دهد که Goroutineها به‌گونه‌ای منتظر یکدیگر یا یک Resource باشند که هیچ‌کدام نتوانند ادامه اجرا دهند.
</p>

```go
func main() {
    ch := make(chan int)

    ch := - 10

    fmt.Println(<-ch)
}
```
<p dir="rtl">
در این مثال Main Goroutine قبل از Receive تلاش می‌کند روی یک Unbuffered Channel مقدار ارسال کند. چون Receiverی وجود ندارد، Send Block می‌شود.
</p>

<p dir="rtl">
Go Runtime در برخی شرایط می‌تواند Deadlockهایی را که کل برنامه در آن‌ها متوقف شده است تشخیص دهد، اما قادر به تشخیص تمام Deadlockهای منطقی برنامه نیست.
</p>

<h2 dir="rtl"> 🌱 تفاوت Race Condition و Data Race چیست؟</h2>

<p dir="rtl">
Race Condition یک مفهوم عمومی‌تر است و زمانی رخ می‌دهد که نتیجه برنامه به Timing یا ترتیب اجرای Concurrent عملیات وابسته باشد.
</p>

<p dir="rtl">
Data Race حالت مشخص‌تری است که در آن چند Execution Context به یک Memory Location دسترسی دارند، حداقل یکی از دسترسی‌ها Write است و Synchronization مناسب وجود ندارد.
</p>


```go
var counter int

go func() {
    counter++
}()

go func() {
    counter++
}()
```
<p dir="rtl">
در این مثال چند Goroutine به یک متغیر مشترک دسترسی دارند و <code>counter++</code> نیز یک عملیات Atomic محسوب نمی‌شود.
</p>

<h2 dir="rtl"> 🌱 Goroutine Leak چیست؟</h2>

<p dir="rtl">
Goroutine Leak زمانی رخ می‌دهد که Goroutine دیگر مورد نیاز نیست، اما به دلیل Block شدن یا عدم وجود مکانیزم پایان، همچنان در حال اجرا باقی می‌ماند.
</p>

<p dir="rtl">
برای مثال Goroutine ممکن است برای همیشه منتظر دریافت از Channelی بماند که هیچ‌وقت مقداری دریافت نمی‌کند.
</p>

<p dir="rtl">
این مشکل در برنامه‌های طولانی‌مدت می‌تواند باعث افزایش تدریجی مصرف Memory و منابع شود.
</p>

<p dir="rtl">
برای جلوگیری از آن باید Lifecycle Goroutineها مشخص باشد و معمولاً از Context Cancellation، Done Channel یا Closing صحیح Channelها استفاده شود.
</p>

<h2 dir="rtl"> 🌱 Starvation چیست و چه تفاوتی با Deadlock دارد؟</h2>

<p dir="rtl">
Starvation زمانی رخ می‌دهد که یک Goroutine یا Task برای مدت بسیار طولانی فرصت دسترسی به CPU، Lock یا Resource مورد نیاز خود را پیدا نمی‌کند، در حالی که سیستم کاملاً متوقف نشده است.
</p>

<p dir="rtl">
در Deadlock، مجموعه‌ای از عملیات در وضعیتی قرار می‌گیرند که هیچ‌کدام نمی‌توانند ادامه پیدا کنند.
</p>

<p dir="rtl">
اما در Starvation ممکن است سایر Goroutineها همچنان به فعالیت خود ادامه دهند و فقط یک یا چند Goroutine فرصت کافی برای پیشرفت نداشته باشند.
</p>

<h2 dir="rtl"> 🌱 چگونه Data Race را در پروژه Go پیدا کنیم؟</h2>

<p dir="rtl">
Go دارای Race Detector داخلی است.
</p>

<pre dir="ltr"><code>go test -race ./...</code></pre>

<p dir="rtl">
برای اجرای برنامه:
</p>

<pre dir="ltr"><code>go run -race .</code></pre>

<p dir="rtl">
برای Build:
</p>

<pre dir="ltr"><code>go build -race .</code></pre>

<p dir="rtl">
Race Detector با Instrument کردن Memory Accessها تلاش می‌کند Raceهایی را که در Execution مشاهده‌شده رخ داده‌اند شناسایی کند.
</p>

<p dir="rtl">
بنابراین اجرای Testهای Concurrent مختلف اهمیت زیادی دارد؛ زیرا Race Detector نمی‌تواند Raceای را که در مسیر اجرای فعلی اتفاق نیفتاده است، تضمیناً پیدا کند.
</p>

<h2 dir="rtl"> 🌱 چگونه یک برنامه Concurrent را Debug و Profile می‌کنیم؟</h2>

<p dir="rtl">
برای پیدا کردن Data Race می‌توان از Race Detector استفاده کرد.
</p>

<p dir="rtl">
برای بررسی Performance و منابع نیز ابزارهایی مانند <code>pprof</code> و Go Execution Trace کاربرد دارند.
</p>

<p dir="rtl">
Goroutine Profile برای بررسی تعداد و Stack Goroutineهای فعال مفید است. Mutex Profile و Block Profile نیز برای بررسی Contention و Blocking کاربرد دارند.
</p>

<p dir="rtl">
در یک برنامه Concurrent باید علاوه بر CPU و Memory، مواردی مانند تعداد Goroutineها، Lock Contention، Channel Blocking و Goroutine Leak نیز بررسی شوند.
</p>

<h2 dir="rtl"> 🌱 چرا این کد مشکل Race دارد؟</h2>


```go
var counter int

for i := 0; i &lt; 100; i++ {
    go func() {
        counter++
    }()
}
```
<p dir="rtl">
چند Goroutine به‌صورت Concurrent متغیر مشترک <code>counter</code> را تغییر می‌دهند.
</p>

<p dir="rtl">
عملیات <code>counter++</code> یک عملیات Atomic نیست و شامل Read، محاسبه و Write است.
</p>

<p dir="rtl">
راهکار اول استفاده از Mutex است. برای یک Counter ساده نیز می‌توان از Atomic استفاده کرد.
</p>

<p dir="rtl">
این کد یک مشکل دیگر هم دارد: برنامه هیچ تضمینی نمی‌دهد که Goroutineها قبل از پایان Main کار خود را تمام کنند. بنابراین علاوه بر Synchronization روی Counter باید برای انتظار پایان Goroutineها نیز از WaitGroup یا مکانیزم مناسب دیگری استفاده شود.
</p>

<h2 dir="rtl"> 🌱 چرا این کد Deadlock می‌شود؟</h2>


```go
func main() {
    ch := make(chan int)

    ch :=- 10

    fmt.Println(<-ch)
}
```
<p dir="rtl">
Channel یک Unbuffered Channel است. برای Send روی چنین Channelی باید یک Receiver هم آماده باشد.
</p>

<p dir="rtl">
Main Goroutine قبل از رسیدن به خط Receive روی Send Block می‌شود.
</p>

<p dir="rtl">
چون Goroutine دیگری وجود ندارد که مقدار را دریافت کند، برنامه دیگر نمی‌تواند به خط بعدی برسد و Deadlock اتفاق می‌افتد.
</p>

<h2 dir="rtl"> 🌱 این Worker چه مشکلی دارد؟</h2>


```go
func worker(ch chan int) {
    for {
        value := <--ch
        fmt.Println(value)
    }
}
```
<p dir="rtl">
Worker هیچ مکانیزمی برای پایان دادن به Loop ندارد. اگر Producer دیگر مقداری ارسال نکند، Worker روی Receive Block خواهد شد.
</p>

<p dir="rtl">
یکی از راهکارها استفاده از Channel Close است:
</p>

```go
for value := range ch {
    fmt.Println(value)
}
```
<p dir="rtl">
راهکار دیگر استفاده از Context است، مخصوصاً زمانی که Worker باید بتواند علاوه بر دریافت Job به Cancellation نیز واکنش نشان دهد.
</p>
