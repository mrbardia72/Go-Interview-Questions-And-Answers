
<h2 dir="rtl"> 🌱 1: چگونه می‌توان Memory Leak را در برنامه‌های Go شناسایی و مدیریت کرد؟</h2>

<p dir="rtl">
Go دارای Garbage Collector است، اما همچنان Memory Leak ممکن است اتفاق بیفتد. اگر برنامه همچنان به یک Object Reference داشته باشد، Garbage Collector نمی‌تواند آن را جمع‌آوری کند.
</p>

<p dir="rtl">
موارد رایج عبارت‌اند از:
</p>

<ul dir="rtl">
<li>Goroutine Leak</li>
<li>Cacheهایی که هیچ‌وقت پاک نمی‌شوند</li>
<li>Reference به Sliceهای بزرگ</li>
<li>Channelهایی که Goroutineها روی آن‌ها منتظر می‌مانند</li>
<li>Timer و Tickerهایی که مدیریت صحیحی ندارند</li>
<li>Global State غیرضروری</li>
</ul>

<p dir="rtl">
برای بررسی مصرف Heap می‌توان از Pprof استفاده کرد.
</p>

---

<h2 dir="rtl"> 🌱 2: آیا Pointer همیشه روی Heap ذخیره می‌شود؟</h2>

<p dir="rtl">
خیر. این یک تصور اشتباه رایج است.
</p>

<p dir="rtl">
اینکه یک Variable در Stack یا Heap قرار بگیرد، توسط Escape Analysis کامپایلر مشخص می‌شود و صرفاً Pointer بودن Variable به معنی Heap Allocation نیست.
</p>

<p dir="rtl">
برای مشاهده نتیجه Escape Analysis می‌توان از دستور زیر استفاده کرد:
</p>

```go
go build -gcflags="-m" .
```
<p dir="rtl"> بنابراین نباید گفت «تمام Pointerها روی Heap قرار می‌گیرند». </p>
<h2 dir="rtl"> 🌱 3: Escape Analysis چیست؟</h2> <p dir="rtl"> Escape Analysis یکی از تحلیل‌هایی است که Compiler انجام می‌دهد تا مشخص کند یک مقدار می‌تواند روی Stack قرار بگیرد یا باید به Heap منتقل شود. </p> <p dir="rtl"> اگر Compiler تشخیص دهد که Lifetime یک مقدار از Scope فعلی فراتر می‌رود، ممکن است آن مقدار Escape کند. </p> <p dir="rtl"> برای مشاهده اطلاعات Escape Analysis: </p>

```go
go build -gcflags="-m" .
```
<h2 dir="rtl"> 🌱 4: Stack و Heap چه تفاوتی دارند؟</h2> <p dir="rtl"> Stack برای مدیریت حافظه مرتبط با Call Stack و داده‌های دارای Lifetime مناسب برای Stack استفاده می‌شود و مدیریت آن بسیار ساده و سریع است. </p> <p dir="rtl"> Heap برای داده‌هایی استفاده می‌شود که Lifetime آن‌ها نمی‌تواند به شکل مناسب در Stack مدیریت شود و Garbage Collector مسئول مدیریت آن‌هاست. </p> <p dir="rtl"> با این حال، نباید تصور کرد که «Heap همیشه بد» یا «Stack همیشه سریع‌تر در تمام شرایط» است؛ تصمیم نهایی به الگوی دسترسی و رفتار برنامه بستگی دارد. </p> ```
