# Go-Interview-Questions-And-Answers
![Image of Yaktocat](Go-interview-Questions.jpg)


 <h2 id="-" dir="rtl" style="color:darkmagenta"> 🌱چه تایپی های مقدار zero آن ها nil هست؟</h2>  
 <p>interfaces, slices, channels, maps, pointers and functions.</p>

 <h2 id="-" dir="rtl"> 🌱تایپ های نوع Reference؟</h2>  
 <p>Pointers, slices, maps, functions, and channels</p>
 
 <h2 id="-" dir="rtl"> 🌱تایپ های نوع Aggregate؟</h2>  
 <p>Array and structs</p>
 
 <h2 id="-" dir="rtl">🌱چه وقت باید از پوینتر استفاده کنیم؟</h2>   
 <p dir="rtl">
1- تابعی که یکی از پارامترهای خود را تغییر می‌دهد
<br>
-وقتی تابعی را فراخوانی می‌کنیم که یک پوینتر را به عنوان پارامتر می‌گیرد، انتظار داریم که متغیر ما تغییر داده شود. اگر شما متغیر را در تابع خود تغییر نمی‌دهید، پس احتمالا نباید از پوینتر استفاده کنید.
 </p>
 <p dir="rtl">
2- عملکرد بهتر
<br>
-اگر رشته‌ای داشته باشید که شامل یک رمان کامل در حافظه باشد، کپی کردن این متغیر هر بار که به یک تابع جدید ارسال می‌شود، کاری بسیار گران است. ممکن است ارزشمند باشد که به جای این کار یک پوینتر را ارسال کنید، که باعث صرفه‌جویی در پردازنده و حافظه می‌شود. با این حال انجام این کار به قمیت خوانا بودن است، بنابراین فقط در صورت لزوم این بهینه‌سازی را انجام دهید.
  </p>
 <p dir="rtl">
3- به گزینه Nil نیاز دارید
<br>
-گاهی اوقات یک تابع باید بداند که مقدار یک چیزی چیست، همچنین باید وجود یا عدم وجود آن را بداند. معمولا هنگام خواندن JSON از این استفاده می‌کنیم تا بدانیم فیلدی وجود دارد یا خیر.
 </p>
 
<h2 id="-" dir="rtl">مزایای زبان گولنگ</h2>  
<p>

* Compilation time is fast
* InBuilt concurrency support: light-weight processes (via goroutines), channels, select statement
* Conciseness, Simplicity, and Safety.
* Production of statically linked native binaries without external dependencies.
* Support for Interfaces and Type embdding.
<br>

Embedded

```go
type PremiumDiscount struct{
    Discount //Embedded
    additional float32
}
```

by-value

```go
type Parent struct{
    value int64
}

func (i *Parent) Value() int64{
    return i.value
}

type Child struct{
    Parent
    multiplier int64
}

func (i Child) Value() int64{
    return i.value * i.multiplier
}
```
By-Pointer
```go
type Bitmap struct{
    data [4][4]bool
}

type Renderer struct{
    *Bitmap //Embed by pointer
    on uint8
    off uint8
}
```
Embed an interface
```go
type echoer struct{
    io.Reader
}
```
Embedding an interface by pointer
```go
type echoer struct{
    *io.Reader
}
```

</p>
