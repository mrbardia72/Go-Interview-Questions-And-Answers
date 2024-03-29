
 <h2 dir="rtl"> 🌱 1: چه تایپ هایی مقدار zero آن ها nil هست؟</h2>

* interfaces
* slices
* channels
* maps
* pointers  
* functions

---

 <h2 dir="rtl"> 🌱 2: تایپ های نوع Reference؟</h2>  

* Pointers
* slices
* maps
* functions
* channels

---

 <h2 dir="rtl"> 🌱 3: تایپ های نوع Aggregate؟</h2>  

* Array 
* structs

---

<h2 dir="rtl">🌱 4: چه وقت باید از پوینتر استفاده کنیم؟</h2>
 <p dir="rtl">
1- تابعی که یکی از پارامترهای خود را تغییر می‌دهد
<br>
-وقتی تابعی را فراخوانی می‌کنیم که یک پوینتر را به عنوان پارامتر می‌گیرد، انتظار داریم که متغیر ما تغییر داده شود. اگر شما متغیر را در تابع خود تغییر نمی‌دهید، پس احتمالا نباید از پوینتر استفاده کنید.
 </p>
 <p dir="rtl">
2- عملکرد بهتر
<br>
-اگر رشته‌ای داشته باشید که شامل یک رمان کامل در حافظه باشد، کپی کردن این متغیر هر بار که به یک تابع جدید ارسال می‌شود، کاری بسیار گران است. ممکن است ارزشمند باشد که به جای این کار یک پوینتر را ارسال کنید، که باعث صرفه‌جویی در پردازنده و حافظه می‌شود. با این حال انجام این کار به قیمت خوانا بودن است، بنابراین فقط در صورت لزوم این بهینه‌سازی را انجام دهید.
  </p>
 <p dir="rtl">
3- به گزینه nil نیاز دارید
<br>
-گاهی اوقات یک تابع باید بداند که مقدار یک چیزی چیست، همچنین باید وجود یا عدم وجود آن را بداند. معمولا هنگام خواندن JSON از این استفاده می‌کنیم تا بدانیم فیلدی وجود دارد یا خیر.
 </p>

---

 <h2 dir="rtl"> 🌱 5: زبان گولنگ از موارد زیر پشتیبانی نمی کند</h2>

* type inheritance
* operator overloading
* method overloading
* pointer arithmetic
* struct type in consts


---

 <h2  dir="rtl"> 🌱 8: چرا کپی کردن pointer کند تر از کپی کردن مقدار هست؟</h2>  
 <p   dir="rtl">
- برای ارسال مقادیر کوچیکی که به مقدارشون فقط نیاز داریم از پوینتر استفاده نکنیم. <br>
- توی متغیرهای کوچیک (کمتر از ۳۲کیلوبایت) کپی کردن یک پوینتر تقریبا به اندازه کپی کردن مقدار اون متغیر هزینه داره  پس از این جهت سودی نمیبریم.<br>
- کامپایلر چک هایی رو تولید میکنه که موقع ران‌تایم زمان dereferencing پوینتر اجرا میشن.<br>
- پوینتر ها اکثرا توی Heap ذخیره میشن<br>
- برای این کار از ابزار های Go استفاده میکنیم ( go build -gcflags="-m" main.go )<br>
- اما اگر به صورت مقداری برگردونیم در stack ذخیره میشه.<br>
- همونطوری که میدونیم ذخیره در stack بسیار بهینه تر هست.<br>
- درواقع Garbage collector میاد heap رو چک میکنه و همونطوری که میدونیم هربار GC درحال بررسی هست به مدت چند میلی‌ثانیه کل سرویس ما فریز میشه. و میتونه مشکل هایی مثل Memory Leak و .. بوجود بیاد<br>
 </p>

---
 <h2  dir="rtl"> 🌱 9: تفاوت بین تایپ *string و sql.nullstring  </h2>  
 <p  dir="rtl">
در واقع SQL دارای مقادیر null متفاوتی نسبت به Golang است.
اگر به تعریف sql.NullString نگاه کنید توی کتابخونه ش،به صورت زیر هست تایپ تعریف شدش:
</p>

```go
type NullString struct {
    String string
    Valid  bool // Valid is true if String is not NULL
}
```

 <p  dir="rtl">
همانطور که می بینید sql.NullString راهی برای نمایش رشته های null از SQL است. 
<br>
از طرف دیگر، یک *string یک اشاره گر به رشته ای است که nil است، بنابراین این دو با هم متفاوت هستند.
 </p>

---
 <h2  dir="rtl"> 🌱 چطور می‌توانید memory leak در برنامه‌های نوشته شده به وسیله Golang را شناسایی و مدیریت کنید؟  </h2>  
 <p  dir="rtl">
برای شناسایی memory leaks در Golang، می‌توان از ابزارهایی مانند pprof به همراه نمودارهای ساخته شده بر اساس heap dumps استفاده کرد. برای پیشگیری از memory leaks، باید دقت کرد که از داده‌ها به درستی استفاده شود، حافظه رزرو شده آزاد گردد و منابع بسته شوند هنگامی که دیگر نیازی به آنها نیست. 
 </p>

---
 <h2  dir="rtl"> 🌱 در Golang چگونه می‌توانیم dependency management را انجام دهیم؟  </h2>  
 <p  dir="rtl">
Golang از Go Modules برای مدیریت وابستگی‌ها استفاده می‌کند که به توسعه دهندگان امکان می‌دهد پروژه‌ها را به صورت مستقل از GOPATH راحت‌تر مدیریت کنند. با استفاده از دستوراتی مانند go mod init, go mod tidy, و go mod vendor می‌توان وابستگی‌های لازم برای پروژه را مدیریت کرد. 
 </p>

---
 <h2  dir="rtl"> 🌱 توضیح دهید که defer statement چیست و چرا ممکن است از آن استفاده کنیم.  </h2>  
 <p  dir="rtl">
Defer statement برای تضمین اجرای یک تابع مشخص، درست قبل از خارج شدن از تابع فعلی استفاده می‌شود. این برای راحتی در مدیریت منابع مثل بستن فایل‌ها و ارتباطات شبکه استفاده می‌شود که می‌خواهیم اطمینان حاصل کنیم که بدرستی بسته خواهند شد. 
 </p>

---
 <h2  dir="rtl"> 🌱 توضیح دهید که واحد ایزوله برای کد نویسی در Golang چیست (table-driven tests) و چرا مفید است.  </h2>  
 <p  dir="rtl">
Table-driven tests شیوه‌ای برای نوشتن تست‌ها است که از جداول داده برای تعریف چندین case تست بهره می‌برد. این شیوه مفید است زیرا کد تست را می‌توان برای بسیاری از داده‌ها به راحتی توسعه داد و به خوبی سازماندهی می‌ش 
 </p>

---
 <h2  dir="rtl"> 🌱 چه تفاوتی میان make و new در Golang وجود دارد؟  </h2>  
 <p  dir="rtl">
make در Go برای ایجاد sliceها، maps و channels استفاده می‌شود و یک ابجکت از نوع مورد نظر را با مقدار اولیه مشخصی برمی‌گرداند. از طرفی new یک pointer به یک ابجکت از یک نوع داده‌ای تعریف شده توسط کاربر را برمی‌گرداند که صفر اولیه شده است. 
 </p>

---
 <h2  dir="rtl"> 🌱 متود (method) receivers در Golang چگونه کار می‌کند و تفاوت بین استفاده از pointer receiver و value receiver چیست؟  </h2>  
 <p  dir="rtl">
Method receivers در Go اجازه می‌دهند تا روی نوع معینی از مقادیر عملیات انجام دهیم. استفاده از pointer receiver به ما اجازه می‌دهد تا تغییراتی که در method روی receiver اعمال می‌شوند را بر روی خود ابجکت اصلی اعمال کنیم، در حالیکه استفاده از value receiver یک کپی از مقدار را می‌گیرد و تغییرات او روی کپی صورت می‌گیرد و بر ابجکت اصلی اثر نمی‌گذارد. 
 </p>

---
 <h2  dir="rtl"> 🌱 چگونه می‌توان در Golang یک پکیج اختصاصی ایجاد کرد و چگونه می‌توان آن را در دیگر فایل‌های Go مورد استفاده قرار داد؟  </h2>  
 <p  dir="rtl">
برای ایجاد پکیج اختصاصی در Go، کد مربوطه باید در یک دایرکتوری قرار داده شود و بالای فایل‌های Go باید package mypackage تعریف شود. برای استفاده از پکیج، import "path/to/mypackage" باید در دیگر فایل‌ها قرار داده شود 
 </p>

---
 <h2  dir="rtl"> 🌱 در Golang، چگونه می‌توانید error handling را اجرا کنید و چه روش‌هایی برای پیاده‌سازی custom error types وجود دارد؟  </h2>  
 <p  dir="rtl">
Error handling در Go اغلب از طریق بازگرداندن ارور از توابع و بررسی آنها انجام می‌شود. برای ایجاد custom error types، می‌توانید از errors.New() برای ایجاد یک ارور ساده استفاده کنید یا یک تایپ که ارور را پیاده‌سازی می‌کند با متدهای اضافی برای داده‌های اضافی ذربط به ارور ایجاد کرد. 
 </p>

---
 <h2  dir="rtl"> 🌱   </h2>  
 <p  dir="rtl">
جواب 
 </p>

---