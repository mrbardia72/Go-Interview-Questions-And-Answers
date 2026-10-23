<h2 dir="rtl"> 🌱 چه زمانی از Channel و چه زمانی از Mutex استفاده می‌شود؟</h2>

<p dir="rtl">
Channel بیشتر برای ارتباط و انتقال داده یا مالکیت بین Goroutineها مناسب است، در حالی که Mutex برای محافظت از داده یا State مشترک استفاده می‌شود.
</p>

<p dir="rtl">
اگر چند Goroutine نیاز داشته باشند Job یا Data را به یکدیگر منتقل کنند، Channel انتخاب طبیعی است.
</p>

<p dir="rtl">
اگر چند Goroutine یک Map، Counter یا State مشترک را تغییر می‌دهند، معمولاً Mutex یا در بعضی موارد Atomic انتخاب مناسب‌تری است.
</p>

<p dir="rtl">
بنابراین نباید تصور کرد که Channel همیشه بهتر از Mutex است. انتخاب صحیح به مسئله بستگی دارد.
</p>

<h2 dir="rtl"> 🌱 تفاوت Buffered Channel و Unbuffered Channel چیست؟</h2>

<p dir="rtl">
Unbuffered Channel ظرفیتی برای نگهداری مقدار ندارد. در نتیجه Send و Receive باید با یکدیگر Synchronize شوند.
</p>

<pre dir="ltr"><code>ch := make(chan int)</code></pre>

<p dir="rtl">
در این حالت ارسال مقدار تا زمانی که Receiver آماده دریافت نباشد، Block می‌شود.
</p>

<p dir="rtl">
در Buffered Channel ظرفیت مشخصی وجود دارد:
</p>

<pre dir="ltr"><code>ch := make(chan int, 10)</code></pre>

<p dir="rtl">
در این حالت Send تا زمانی که Buffer پر نشده باشد می‌تواند بدون منتظر ماندن برای Receiver ادامه پیدا کند.
</p>

<p dir="rtl">
اگر Buffer پر شود، Send Block می‌شود و اگر Buffer خالی باشد، Receive Block می‌شود.
</p>


<h2 dir="rtl"> 🌱 Nil Channel چیست و عملیات روی آن چه رفتاری دارد؟</h2>

<p dir="rtl">
اگر یک Channel مقداردهی نشده باشد، مقدار آن <code>nil</code> است.
</p>

<pre dir="ltr"><code>var ch chan int</code></pre>

<p dir="rtl">
ارسال یا دریافت از Nil Channel برای همیشه Block می‌شود:
</p>

```go
ch := 10
value := <-ch
```

<p dir="rtl">
اما بستن Nil Channel باعث Panic می‌شود:
</p>

<pre dir="ltr"><code>close(ch)</code></pre>

<p dir="rtl">
Nil Channel در ترکیب با <code>select</code> کاربرد مهمی دارد؛ زیرا Case مربوط به Nil Channel عملاً غیرفعال می‌شود.
</p>

<h2 dir="rtl"> 🌱 تفاوت <code>close(channel)</code> با ارسال مقدار به Channel چیست؟</h2>

<p dir="rtl">
ارسال مقدار یعنی Producer یک Data را برای Consumer ارسال می‌کند، اما <code>close</code> اعلام می‌کند که دیگر مقداری قرار نیست از آن Channel ارسال شود.
</p>

<p dir="rtl">
پس از بسته شدن Channel همچنان می‌توان مقادیر موجود در Buffer را دریافت کرد.
</p>

<p dir="rtl">
پس از تمام شدن مقادیر، Receive از Channel بسته‌شده مقدار Zero Value مربوط به نوع را برمی‌گرداند.
</p>

<pre dir="ltr"><code>value, ok := &lt;-ch</code></pre>

<p dir="rtl">
اگر <code>ok == false</code> باشد، یعنی Channel بسته شده و دیگر مقداری برای دریافت وجود ندارد.
</p>

<p dir="rtl">
ارسال روی Channel بسته‌شده و بستن دوباره Channel باعث Panic می‌شود.
</p>

<p dir="rtl">
معمولاً Producer یا مالک Channel مسئول Close کردن آن است.
</p>

<h2 dir="rtl"> 🌱 <code>select</code> در Go چگونه کار می‌کند؟</h2>

<p dir="rtl">
<code>select</code> برای انتظار همزمان روی چند عملیات Channel استفاده می‌شود.
</p>

```go
select {
case value := &lt;-ch1:
    fmt.Println(value)

case value := &lt;-ch2:
    fmt.Println(value)

default:
    fmt.Println("nothing ready")
}
```
<p dir="rtl">
اگر چند Case همزمان آماده باشند، Go یکی از Caseهای آماده را انتخاب می‌کند و نباید روی ترتیب خاصی حساب کرد.
</p>

<p dir="rtl">
اگر هیچ Caseای آماده نباشد و <code>default</code> وجود داشته باشد، <code>default</code> اجرا می‌شود.
</p>

<p dir="rtl">
اگر هیچ Caseای آماده نباشد و Default نیز وجود نداشته باشد، Goroutine منتظر می‌ماند تا یکی از Caseها آماده شود.
</p>

<h2 dir="rtl"> 🌱 آیا Channel باعث جلوگیری از Data Race می‌شود؟</h2>

<p dir="rtl">
Channel می‌تواند Synchronization و انتقال امن داده بین Goroutineها را فراهم کند، اما صرف استفاده از Channel تضمین نمی‌کند که تمام برنامه بدون Data Race باشد.
</p>

<p dir="rtl">
اگر چند Goroutine همچنان مستقیماً به یک Memory مشترک دسترسی داشته باشند و Synchronization مناسبی وجود نداشته باشد، همچنان امکان Data Race وجود دارد.
</p>

<p dir="rtl">
بنابراین باید کل Access Pattern برنامه را بررسی کرد، نه اینکه صرفاً وجود Channel را به عنوان تضمین نبود Race در نظر گرفت.
</p>

<h2 dir="rtl"> 🌱 آیا Buffered Channel همیشه بهتر از Unbuffered Channel است؟</h2>

<p dir="rtl">
خیر. Buffer فقط یک رفتار متفاوت برای Synchronization ایجاد می‌کند و الزاماً Performance را بهتر نمی‌کند.
</p>

<p dir="rtl">
Unbuffered Channel برای Synchronization مستقیم بین Sender و Receiver بسیار مناسب است.
</p>

<p dir="rtl">
Buffered Channel زمانی مفید است که بخواهیم Producer و Consumer تا حد مشخصی از یکدیگر جدا باشند و Burstهای کوچک را تحمل کنیم.
</p>

<p dir="rtl">
انتخاب ظرفیت Buffer باید بر اساس رفتار واقعی سیستم، محدودیت Memory و Benchmark انجام شود، نه صرفاً با انتخاب یک عدد بزرگ.
</p>

<h2 dir="rtl"> 🌱 Fan-in چیست و چگونه با Channel پیاده‌سازی می‌شود؟</h2>

<p dir="rtl">
Fan-in یعنی چند جریان ورودی را در یک Channel خروجی ترکیب کنیم.
</p>

```go
Worker 1 ---+
Worker 2 ---+--- Output
Worker 3 ---+
```

<p dir="rtl">
برای پیاده‌سازی Fan-in می‌توان چند Channel را با استفاده از Goroutine و <code>select</code> در یک Channel خروجی ادغام کرد.
</p>

<p dir="rtl">
در پیاده‌سازی واقعی باید پایان Inputها، Close شدن Channelها و Cancellation را نیز به‌درستی مدیریت کنیم.
</p>

<h2 dir="rtl"> 🌱 Channel و Memory Synchronization چه ارتباطی دارند؟</h2>

<p dir="rtl">
ارسال و دریافت از Channel علاوه بر انتقال Data می‌تواند بین Goroutineها Synchronization ایجاد کند.
</p>

<p dir="rtl">
به همین دلیل Channel تنها یک Queue ساده نیست؛ بلکه بخشی از مدل Synchronization زبان Go نیز محسوب می‌شود.
</p>

<p dir="rtl">
در برنامه‌های Concurrent باید مشخص باشد که کدام عملیات قبل از ارسال و دریافت انجام شده‌اند و چگونه Happens-Before بین Goroutineها برقرار می‌شود.
</p>
