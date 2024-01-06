
<h2  dir="rtl"> 🌱 فرق بین همزمانی (concurrency) و موازی (parallelism) </h2>
<p  dir="rtl">
موازی‌سازی (parallelism) یعنی چندین فرآیند به‌طور همزمان توسط چند threads یا به طور دقیق‌تر هسته پردازشی انجام شود و این هسته‌ها می‌توانند از طریق حافظه اشتراکی با هم ارتباط برقرار کنند
</p>

<p dir="rtl">
همزمانی به گونه‌ای است که دو یا چند کار مختلف ممکن است به طور همزمان در حال پیشرفت و انجام باشند. و در نهایت این فرآیندهای همزمان به نتایج مختلفی ختم می شوند
</p>

<p dir="rtl">
در زبان Go با استفاده از متغیرهای محیطی GOMAXPROCS در کنار همزمانی از موازی‌سازی (parallelism) هم استفاده می‌شود. هرچند بطور پیش فرض برنامه‌ای که با زبان گو نوشته می‌شود از تمامی هسته‌های CPU استفاده می‌کند ولی شما می‌توانید با GOMAXPROCS تعداد هسته‌ها را محدود کنید. لازم به ذکر است که در زبان Go شما به طور مستقیم نمی‌توانید اجرای موازی زیربرنامه‌ای را به کامپایلر دیکته کنید و تصمیم‌گیری در این مورد به عهده Go Runtime Scheduler است.
</p>

<p dir="rtl">
<a href="https://book.gofarsi.ir/chapter-3/go-concurrency/"> برای اطلاعات بیشتر اینجا کلیک کنید</a>
</p>

---
حدااکثر اندازه یک گوروتینگ چقدر هست
مکانیزیم عملکرد گوروتینگ تابع اصلی یعنی مین چیه
زمانبندی گورتیگ چگونه هست


 <h2  dir="rtl"> 🌱  چه موقعی از channel و چه موقعی از mutex استفاده میشه برای گورتینگ ها؟(بحث ارتباط)؟ </h2>  
 <p  dir="rtl">
معمولاً در مواقعی که Goroutines نیاز به برقراری ارتباط با یکدیگر دارند از channels  استفاده کنید 
و درصورتی که فقط یک Goroutine دارید و باید به بخش مهم کد دسترسی داشته باشد از Mutexes استفاده کنید.
 </p>



---

<h2  dir="rtl"> 🌱  تفاوت بین goroutine و thread را توضیح دهید. </h2>
<p  dir="rtl">
Goroutines سبک وزن هستند و دارای یک استک اولیه کوچک‌تر که به صورت پویا گسترش می‌یابد هستند، این در حالی است که threads استک ثابت دارند. Goroutines هم‌زمانی را در سطح زبان با استفاده از channelها مدیریت می‌کنند، در حالی که threads ممکن است نیاز به lockهای صریح داشته باشند. همچنین، سوئیچینگ بین goroutines کارایی بیشتری نسبت به thread switching دارد.
</p>


---
<h2  dir="rtl"> 🌱 چه زمانی یک channel در Golang باید با buffer مورد استفاده قرار گیرد؟  </h2>
<p  dir="rtl">
یک channel با buffer زمانی مورد استفاده قرار گیرد که شما می‌خواهید ارتباطات بین goroutines را بدون ایجاد blocking فوری داشته باشید. این امر می‌تواند بازده کدها را در مواقعی که عملیات‌ها از لحاظ عملکرد اندکی نابرابر هستند، بهبود بخشد.
</p>

---
<h2  dir="rtl"> 🌱 در Golang چگونه می‌توانید اطمینان حاصل کنید که یک goroutine نتیجه‌ای تولید می‌کند قبل از اینکه برنامه کار خود را به طور کامل متوقف کند؟  </h2>
<p  dir="rtl">
برای اطمینان از اینکه یک goroutine کار خود را به اتمام برساند، معمولا از sync.WaitGroup برای همچین مدیریتی استفاده می‌کنیم. ساختار WaitGroup اجازه می‌دهد تا اصلی‌ترین goroutine صبر کند تا یک یا چند goroutines دیگر کار خود را تمام کنند.
</p>

---
<h2  dir="rtl"> 🌱 سوال  </h2>
<p  dir="rtl">
جواب
</p>

---