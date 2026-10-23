<h2 dir="rtl"> 🌱 تفاوت Mutex و RWMutex چیست؟</h2>

<p dir="rtl">
<code>sync.Mutex</code> یک Lock عمومی است که اجازه می‌دهد در یک زمان تنها یک Goroutine وارد بخش محافظت‌شده شود.
</p>

<p dir="rtl">
<code>sync.RWMutex</code> دو نوع Lock دارد: Read Lock و Write Lock.
</p>

```go
mu.RLock()
defer mu.RUnlock()</code></pre>
```
<p dir="rtl">
چند Reader می‌توانند همزمان Read Lock داشته باشند، اما Writer به دسترسی انحصاری نیاز دارد.
</p>

<p dir="rtl">
RWMutex زمانی می‌تواند مفید باشد که Readها بسیار بیشتر از Writeها باشند، اما نباید فرض کرد RWMutex همیشه سریع‌تر از Mutex است.
</p>

<h2 dir="rtl"> 🌱 <code>sync.WaitGroup</code> چگونه کار می‌کند؟</h2>

<p dir="rtl">
WaitGroup برای منتظر ماندن یک Goroutine تا پایان مجموعه‌ای از Goroutineهای دیگر استفاده می‌شود.
</p>

```go
var wg sync.WaitGroup

wg.Add(3)

for i := 0; i &lt; 3; i++ {
    go func() {
        defer wg.Done()
        // work
    }()
}

wg.Wait()
```
<p dir="rtl">
<code>Add</code> Counter را افزایش می‌دهد، <code>Done</code> آن را کاهش می‌دهد و <code>Wait</code> تا صفر شدن Counter منتظر می‌ماند.
</p>

<p dir="rtl">
اگر <code>Done</code> بیشتر از تعداد Addها اجرا شود، ممکن است Panic رخ دهد.
</p>

<p dir="rtl">
WaitGroup برای انتقال Error یا Cancellation طراحی نشده است؛ در چنین شرایطی ابزارهایی مانند <code>errgroup</code> می‌توانند مناسب‌تر باشند.
</p>

<h2 dir="rtl"> 🌱 تفاوت <code>sync.Once</code> و Mutex چیست؟</h2>

<p dir="rtl">
<code>sync.Once</code> برای اجرای یک عملیات دقیقاً یک بار در طول عمر یک Once استفاده می‌شود.
</p>

```go
var once sync.Once

once.Do(func() {
    initialize()
})
```
<p dir="rtl">
اگر چند Goroutine همزمان <code>Do</code> را فراخوانی کنند، Function فقط یک بار اجرا خواهد شد.
</p>

<p dir="rtl">
Mutex یک ابزار عمومی برای محافظت از Critical Section است و می‌تواند بارها Lock و Unlock شود، اما Once برای Initialization One-Time طراحی شده است.
</p>

<h2 dir="rtl"> 🌱 <code>sync/atomic</code> چیست و چه زمانی استفاده می‌شود؟</h2>

<p dir="rtl">
Package <code>sync/atomic</code> عملیات Atomic روی متغیرهای مشخص را فراهم می‌کند.
</p>

```go
atomic.AddInt64(&amp;counter, 1)</code></pre>
```
<p dir="rtl">
Atomic برای Stateهای ساده مانند Counter، Flag یا برخی Pointerها مفید است.
</p>

<p dir="rtl">
اما Atomic جایگزین تمام Mutexها نیست. اگر یک Invariant شامل چند متغیر یا چند مرحله باشد، معمولاً Mutex یا طراحی دیگری لازم است.
</p>

<h2 dir="rtl"> 🌱 چه زمانی Mutex انتخاب بهتری نسبت به Channel است؟</h2>

<p dir="rtl">
اگر هدف اصلی محافظت از یک State مشترک باشد و نیازی به انتقال Job یا Data بین Goroutineها نداشته باشیم، Mutex معمولاً انتخاب ساده‌تر و مستقیم‌تری است.
</p>

<p dir="rtl">
برای مثال اگر چند Goroutine فقط یک Map مشترک را Read و Write می‌کنند، محافظت از Map با Mutex یا RWMutex می‌تواند مناسب باشد.
</p>

<p dir="rtl">
استفاده از Channel برای چنین مسئله‌ای ممکن است باعث پیچیده‌تر شدن طراحی شود.
</p>

<h2 dir="rtl"> 🌱 چگونه Deadlock ناشی از چند Mutex ایجاد می‌شود؟</h2>

<p dir="rtl">
فرض کنید دو Goroutine داریم که دو Lock مشترک را با ترتیب متفاوت دریافت می‌کنند.
</p>

```go
Goroutine 1:
Lock(A)
Lock(B)

Goroutine 2:
Lock(B)
Lock(A)</code></pre>
```
<p dir="rtl">
ممکن است Goroutine اول Lock A را بگیرد و منتظر B باشد، در حالی که Goroutine دوم B را گرفته و منتظر A باشد.
</p>

<p dir="rtl">
در این حالت هر دو منتظر دیگری هستند و Deadlock ایجاد می‌شود.
</p>

<p dir="rtl">
یکی از روش‌های جلوگیری، تعریف یک ترتیب ثابت برای گرفتن Lockها و رعایت همان ترتیب در تمام بخش‌های برنامه است.
</p>

<h2 dir="rtl"> 🌱 آیا Mutex می‌تواند تمام مشکلات Concurrency را حل کند؟</h2>

<p dir="rtl">
خیر. Mutex فقط یک ابزار Synchronization است.
</p>

<p dir="rtl">
Mutex می‌تواند دسترسی همزمان به State مشترک را کنترل کند، اما مشکلاتی مانند Goroutine Leak، Deadlock، Unbounded Queue، Cancellation یا Resource Exhaustion را به‌صورت خودکار حل نمی‌کند.
</p>

<p dir="rtl">
همچنین اگر Lockها به ترتیب نادرستی استفاده شوند، خود Mutex می‌تواند باعث Deadlock شود.
</p>

<h2 dir="rtl"> 🌱 تفاوت Atomic و Mutex چیست؟</h2>

<p dir="rtl">
Atomic برای انجام عملیات‌های مشخص و ساده به‌صورت اتمیک مناسب است، در حالی که Mutex می‌تواند یک Critical Section شامل چندین عملیات را محافظت کند.
</p>

<p dir="rtl">
اگر فقط نیاز داشته باشیم Counter را افزایش دهیم، Atomic می‌تواند انتخاب مناسبی باشد.
</p>

<p dir="rtl">
اما اگر چند متغیر باید با هم Consistent باقی بمانند، معمولاً Mutex مناسب‌تر است.
</p>

<p dir="rtl">
Atomic لزوماً جایگزین ساده و مستقیم Mutex نیست.
</p>