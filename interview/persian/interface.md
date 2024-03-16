 <h2  dir="rtl"> 🌱 چرا باید از interface استفاده کنیم؟  </h2>  
 <p dir="ltr">
 To help reduce duplication or boilerplate code. 

To make it easier to use mocks instead of real objects in unit tests.

As an architectural tool, to help enforce decoupling between parts of your codebase.

 </p>

---
 <h2  dir="rtl"> 🌱  آیا در Golang می‌توان از polymorphism استفاده کرد؟ اگر بله، چگونه؟  </h2>  
 <p  dir="rtl">
بله، در Go می‌توان از polymorphism استفاده کرد از طریق استفاده از interfaces. یک interface می‌تواند برای تعریف یک مجموعه از روش‌ها به کار رود و هر نوع که این روش‌ها را پیاده‌سازی کند به عنوان آن نوع interface شناخته شود. 
 </p>

---
 <h2  dir="rtl"> 🌱 چرا Go از ارث بری (inheritance) پشتیبانی نمی‌کند و از composition به عنوان جایگزین استفاده می‌کند؟  </h2>  
 <p  dir="rtl">
Go ارث بری را پیاده‌سازی نمی‌کند زیرا می‌تواند پیچیده شود و معماری نرم افزار را سخت‌تر مدیریت کند. در عوض، از composition استفاده می‌کند که می‌تواند code reuse را تشویق کند و طراحی سیستم را ساده‌تر و مدولارتر می‌کند. 
 </p>

---
 <h2  dir="rtl"> 🌱 توضیح دهید که interface در Golang چیست و چگونه می‌تواند مورد استفاده قرار گیرد.  </h2>  
 <p  dir="rtl">
یک interface در Go یک نوع خاص است که مجموعه‌ای از method signatures را تعریف می‌کند. هر نوع داده‌ای که این متدها را پیاده سازی کند، می‌تواند به عنوان آن interface مورد استفاده قرار گیرد. این بدون نیاز به ارث بری صورت می‌گیرد و امکان داکتایپینگ را فراهم می‌کند. 
 </p>

---

 <h2  dir="rtl"> 🌱   </h2>  
 <p  dir="rtl">
جواب 
 </p>

---