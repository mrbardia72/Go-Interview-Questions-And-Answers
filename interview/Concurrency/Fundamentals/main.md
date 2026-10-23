<h2 dir="rtl"> 🌱 تفاوت بین همزمانی (Concurrency) و موازی‌سازی (Parallelism) چیست؟</h2>

<p dir="rtl">
Concurrency به معنی مدیریت و پیشرفت همزمان چند کار مستقل است؛ یعنی چند Task می‌توانند در یک بازه زمانی در حال پیشرفت باشند، حتی اگر در هر لحظه فقط یکی از آن‌ها واقعاً روی CPU اجرا شود.
</p>

<p dir="rtl">
Parallelism به معنی اجرای واقعی چند Task در یک زمان روی چند واحد پردازشی است. بنابراین Parallelism معمولاً زمانی اتفاق می‌افتد که چند هسته CPU در اختیار Runtime قرار داشته باشند.
</p>

<p dir="rtl">
اگر یک CPU تک‌هسته‌ای داشته باشیم، برنامه می‌تواند Concurrent باشد اما اجرای واقعی Parallel نداشته باشد. در مقابل، روی یک CPU چند هسته‌ای چند Goroutine می‌توانند به‌صورت واقعی روی هسته‌های مختلف اجرا شوند.
</p>

<p dir="rtl">
در Go، Goroutineها ابزار اصلی برای ساخت برنامه‌های Concurrent هستند و Go Runtime Scheduler مشخص می‌کند که Goroutineها چگونه روی OS Threadها اجرا شوند. مقدار <code>GOMAXPROCS</code> تعداد Logical Processorهایی را که می‌توانند همزمان کد Go را اجرا کنند محدود می‌کند.
</p>

<p dir="rtl">
بنابراین Concurrency یک مفهوم مربوط به ساختار و مدیریت چند Task است، در حالی که Parallelism به اجرای واقعی همزمان آن Taskها مربوط می‌شود.
</p>

<h2 dir="rtl"> 🌱 حداکثر اندازه یک Goroutine چقدر است؟</h2>

<p dir="rtl">
Goroutine مانند یک OS Thread با یک Stack بزرگ و ثابت ایجاد نمی‌شود. Goroutine در ابتدا Stack کوچکی دارد و Runtime در صورت نیاز Stack آن را به‌صورت پویا افزایش می‌دهد.
</p>

<p dir="rtl">
بنابراین نمی‌توان گفت هر Goroutine از ابتدا چند مگابایت حافظه مصرف می‌کند. مصرف حافظه آن به Stack مورد نیاز، Heap Allocationها و منابع دیگری که Goroutine استفاده می‌کند بستگی دارد.
</p>

<p dir="rtl">
تعداد Goroutineها نیز از نظر مفهومی محدود به یک عدد کوچک و ثابت نیست؛ اما در عمل حافظه سیستم، تعداد Threadهای مورد نیاز، منابع I/O و سایر محدودیت‌های برنامه تعیین می‌کنند چه تعداد Goroutine منطقی است.
</p>

<p dir="rtl">
سبک بودن Goroutine به معنی رایگان بودن آن نیست. ایجاد تعداد بسیار زیاد Goroutine بدون طراحی صحیح می‌تواند باعث مصرف زیاد حافظه، Scheduler Overhead یا Goroutine Leak شود.
</p>


<h2 dir="rtl"> 🌱 مکانیزم اجرای <code>main</code> و Goroutine اصلی در Go چگونه است؟</h2>

<p dir="rtl">
پس از شروع برنامه، Go Runtime محیط اجرای برنامه را راه‌اندازی می‌کند و تابع <code>main.main</code> را اجرا می‌کند.
</p>

<p dir="rtl">
اگر داخل <code>main</code> یک Goroutine دیگر ایجاد کنیم، Runtime آن Goroutine را برای اجرا در اختیار Scheduler قرار می‌دهد؛ اما هیچ تضمینی وجود ندارد که Goroutine جدید قبل از پایان <code>main</code> اجرا شود.
</p>

<p dir="rtl">
زمانی که تابع <code>main</code> تمام شود، کل Process خاتمه پیدا می‌کند و Goroutineهای دیگری که هنوز در حال اجرا هستند نیز فرصت ادامه اجرای خود را از دست می‌دهند.
</p>

<p dir="rtl">
بنابراین برای منتظر ماندن برای Goroutineها باید از مکانیزم‌هایی مانند <code>sync.WaitGroup</code>، Channel یا Context استفاده کنیم.
</p>

<h2 dir="rtl"> 🌱 Go Scheduler چگونه Goroutineها را زمان‌بندی می‌کند؟</h2>

<p dir="rtl">
Go Runtime دارای Scheduler اختصاصی است که Goroutineها را روی OS Threadها زمان‌بندی می‌کند. مدل مفهومی معروف Scheduler در Go با سه جزء <code>G</code>، <code>M</code> و <code>P</code> توضیح داده می‌شود.
</p>

<p dir="rtl">
<code>G</code> نماینده Goroutine، <code>M</code> نماینده OS Thread و <code>P</code> نماینده Logical Processor مورد نیاز برای اجرای کد Go است.
</p>

<p dir="rtl">
Scheduler تلاش می‌کند Goroutineهای آماده اجرا را بین Processorها توزیع کند. یکی از مکانیزم‌های مهم آن Work Stealing است؛ یعنی اگر یک Processor کار کمتری داشته باشد، می‌تواند Goroutineهای قابل اجرا را از صف Processor دیگری دریافت کند.
</p>

<p dir="rtl">
Go Runtime همچنین از Preemption پشتیبانی می‌کند؛ بنابراین Scheduler می‌تواند اجرای Goroutine را متوقف کرده و فرصت اجرا را به Goroutine دیگری بدهد.
</p>

<p dir="rtl">
نباید روی ترتیب اجرای Goroutineها حساب کرد، مگر اینکه خودمان با Synchronization ترتیب را مشخص کرده باشیم.
</p>

<h2 dir="rtl"> 🌱 تفاوت Goroutine و OS Thread چیست؟</h2>

<p dir="rtl">
Goroutine یک واحد اجرای سبک‌وزن در سطح Go Runtime است، در حالی که Thread یک واحد اجرای متعلق به سیستم‌عامل است.
</p>

<p dir="rtl">
Goroutineها Stack اولیه کوچک‌تری دارند و Stack آن‌ها در صورت نیاز به‌صورت پویا مدیریت می‌شود. به همین دلیل ایجاد تعداد زیادی Goroutine معمولاً بسیار ارزان‌تر از ایجاد همان تعداد OS Thread است.
</p>

<p dir="rtl">
Go Runtime تعداد زیادی Goroutine را روی تعداد محدودتری OS Thread زمان‌بندی می‌کند. بنابراین رابطه یک‌به‌یک بین Goroutine و Thread وجود ندارد.
</p>

<p dir="rtl">
Context Switching بین Goroutineها توسط Runtime مدیریت می‌شود و معمولاً نسبت به Context Switching بین OS Threadها هزینه کمتری دارد؛ البته هزینه واقعی به شرایط برنامه و نوع عملیات بستگی دارد.
</p>

<h2 dir="rtl"> 🌱 آیا Goroutine همیشه روی یک OS Thread اجرا می‌شود؟</h2>

<p dir="rtl">
خیر. Goroutine به یک OS Thread خاص Bind نیست.
</p>

<p dir="rtl">
Go Scheduler می‌تواند یک Goroutine را در زمان‌های مختلف روی Threadهای مختلف اجرا کند.
</p>

<p dir="rtl">
در شرایط خاص می‌توان با استفاده از <code>runtime.LockOSThread</code> یک Goroutine را به OS Thread فعلی متصل کرد، اما این یک نیاز تخصصی است و استفاده بی‌دلیل از آن می‌تواند Scheduler را محدود کند.
</p>

<h2 dir="rtl"> 🌱 آیا اجرای Goroutineها ترتیب مشخصی دارد؟</h2>

<p dir="rtl">
خیر. زمانی که چند Goroutine ایجاد می‌کنیم، نباید روی ترتیب اجرای آن‌ها حساب کنیم، مگر اینکه خودمان با Synchronization ترتیب را مشخص کرده باشیم.
</p>

<pre dir="ltr"><code>go fmt.Println("A")
go fmt.Println("B")</code></pre>

<p dir="rtl">
ممکن است <code>A</code> قبل از <code>B</code> چاپ شود یا برعکس.
</p>

<p dir="rtl">
اگر ترتیب مشخصی نیاز داشته باشیم باید از Channel، WaitGroup، Mutex، Context یا سایر Synchronization Mechanismها استفاده کنیم.
</p>

<h2 dir="rtl"> 🌱 تفاوت Concurrency و Parallelism در یک برنامه CPU-Bound و I/O-Bound چیست؟</h2>

<p dir="rtl">
در Workloadهای I/O-Bound، Concurrency می‌تواند باعث شود زمانی که یک Goroutine منتظر I/O است، Goroutine دیگری پیشرفت کند و در نتیجه Resourceها بهتر استفاده شوند.
</p>

<p dir="rtl">
در Workloadهای CPU-Bound، Parallelism می‌تواند باعث شود چند محاسبه واقعاً روی چند CPU Core اجرا شوند.
</p>

<p dir="rtl">
بنابراین نوع Workload در طراحی Concurrent سیستم اهمیت زیادی دارد. افزایش تعداد Goroutineها به‌صورت کورکورانه الزاماً باعث افزایش Performance نمی‌شود.
</p>
