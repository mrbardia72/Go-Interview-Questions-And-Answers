<h2  dir="rtl" align="right" > 🌱 Go Memory Model چیست؟</h2>

<p dir="rtl" align="right">
Go Memory Model مشخص می‌کند چه تضمین‌هایی درباره مشاهده Memory بین Goroutineهای مختلف وجود دارد و چه زمانی یک Read می‌تواند نتیجه Write انجام‌شده توسط Goroutine دیگر را به‌صورت قابل اتکا مشاهده کند.
</p>

<p dir="rtl" align="right">
مفاهیمی مانند Synchronization و Happens-Before در این موضوع اهمیت زیادی دارند.
</p>

<p dir="rtl" align="right">
استفاده صحیح از Mutex، Channel و Atomic Operations می‌تواند رابطه‌های Synchronization مورد نیاز را ایجاد کند.
</p>

<p dir="rtl" align="right">
صرف اینکه یک Goroutine قبل از Goroutine دیگر در Source Code نوشته شده، به معنی وجود یک ترتیب Synchronization بین آن‌ها نیست.
</p>

---

<h2 dir="rtl" align="right"> 🌱 Happens-Before چیست؟</h2>

<p dir="rtl" align="right">
Happens-Before رابطه‌ای در Memory Model است که مشخص می‌کند یک عملیات از نظر Synchronization قبل از عملیات دیگری قرار دارد.
</p>

<p dir="rtl" align="right">
اگر یک Write با مکانیزم Synchronization مناسب قبل از یک Read قرار گرفته باشد، Read می‌تواند نتیجه Write را به‌صورت تضمین‌شده مشاهده کند.
</p>

<p dir="rtl" align="right">
Mutex Lock/Unlock و عملیات Channel از مکانیزم‌هایی هستند که می‌توانند روابط Happens-Before ایجاد کنند.
</p>

<p dir="rtl" align="right">
بدون چنین رابطه‌ای نباید صرفاً بر اساس ترتیب ظاهری Source Code درباره ترتیب مشاهده Memory بین Goroutineها نتیجه‌گیری کرد.
</p>

---

<h2 dir="rtl" align="right"> 🌱 Preemption در Go چیست؟</h2>

<p dir="rtl" align="right">
Preemption به این معنی است که Runtime می‌تواند اجرای یک Goroutine را متوقف کند تا Goroutine دیگری فرصت اجرا پیدا کند.
</p>

<p dir="rtl" align="right">
این موضوع برای جلوگیری از monopolize شدن CPU توسط یک Goroutine اهمیت دارد.
</p>

<p dir="rtl">
نسخه‌های مدرن Go دارای Asynchronous Preemption نیز هستند که امکان Preempt کردن Goroutine را در نقاط بیشتری فراهم می‌کند.
</p>

---

<h2 dir="rtl"> 🌱 مدل G-M-P در Go Scheduler چیست؟</h2>

<p dir="rtl">
مدل G-M-P یک مدل مفهومی برای توضیح Scheduler در Go است.
</p>

<p dir="rtl">
<code>G</code> نماینده Goroutine، <code>M</code> نماینده OS Thread و <code>P</code> نماینده Logical Processor مورد نیاز برای اجرای کد Go است.
</p>

<p dir="rtl">
یک Goroutine برای اجرای کد Go باید روی یک M با یک P قرار گیرد.
</p>

<p dir="rtl">
Scheduler وظیفه دارد Goroutineهای قابل اجرا را بین Pها و Mها مدیریت کند.
</p>

---

<h2 dir="rtl"> 🌱 Work Stealing چیست؟</h2>

<p dir="rtl">
Work Stealing یکی از مکانیزم‌های Scheduler است که به توزیع مناسب‌تر Goroutineهای قابل اجرا کمک می‌کند.
</p>

<p dir="rtl">
اگر یک Processor کار کمتری داشته باشد، Scheduler می‌تواند Goroutineهای قابل اجرا را از صف Processor دیگری دریافت کند.
</p>

<p dir="rtl">
هدف این مکانیزم استفاده بهتر از CPU و جلوگیری از بیکار ماندن Processorها است.
</p>

---

<h2 dir="rtl"> 🌱 Memory Ordering در عملیات Atomic چه اهمیتی دارد؟</h2>

<p dir="rtl">
در برنامه‌های Concurrent تنها Atomic بودن یک عملیات کافی نیست؛ ترتیب مشاهده عملیات Memory نیز اهمیت دارد.
</p>

<p dir="rtl">
Synchronization باید به‌گونه‌ای باشد که ترتیب مورد نیاز برنامه را تضمین کند.
</p>

<p dir="rtl">
در Go این رفتار توسط Memory Model و Semantics مربوط به Synchronization و Atomic Operations تعریف می‌شود.
</p>

<p dir="rtl">
بنابراین نباید فرض کرد Atomic کردن یک متغیر به‌تنهایی تمام Synchronization مورد نیاز یک الگوریتم Concurrent را ایجاد می‌کند.
</p>

---

<h2 dir="rtl"> 🌱 آیا افزایش تعداد Goroutine همیشه باعث افزایش Performance می‌شود؟</h2>

<p dir="rtl">
خیر. تعداد Goroutine بیشتر لزوماً به معنی Performance بیشتر نیست.
</p>

<p dir="rtl">
در Workloadهای CPU-Bound ممکن است تعداد زیاد Goroutine باعث افزایش Scheduling Overhead و Contention شود.
</p>

<p dir="rtl">
در Workloadهای I/O-Bound تعداد بیشتری Goroutine ممکن است مفید باشد، اما همچنان محدودیت‌هایی مانند Database Connection، External API، Memory و Queue Capacity وجود دارند.
</p>

<p dir="rtl">
بنابراین تعداد مناسب Goroutine باید بر اساس نوع Workload، Benchmark و Bottleneck واقعی سیستم تعیین شود.
</p>
