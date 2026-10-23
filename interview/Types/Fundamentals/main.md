<h2 dir="rtl"> 🌱 1: چه تایپ‌هایی مقدار Zero Value آن‌ها nil است؟</h2>

<p dir="rtl">
در Go، مقدار Zero Value برخی از تایپ‌ها <code>nil</code> است. این تایپ‌ها شامل موارد زیر هستند:
</p>

<ul dir="ltr">
<li>Pointer</li>
<li>Slice</li>
<li>Map</li>
<li>Channel</li>
<li>Function</li>
<li>Interface</li>
</ul>

<p dir="rtl">
برای مثال:
</p>

```go
var p *int
var s []int
var m map[string]int
var ch chan int
var f func()
var i interface{}

fmt.Println(p == nil)  // true
fmt.Println(s == nil)  // true
fmt.Println(m == nil)  // true
fmt.Println(ch == nil) // true
fmt.Println(f == nil)  // true
fmt.Println(i == nil)  // true
```
<p dir="rtl"> در مقابل، Zero Value تایپ‌هایی مانند <code>int</code>، <code>float64</code>، <code>bool</code>، <code>string</code>، <code>array</code> و <code>struct</code> برابر <code>nil</code> نیست. </p>
<h2 dir="rtl"> 🌱 2: کدام تایپ‌ها در Go رفتار شبیه Reference Type دارند؟</h2> <p dir="rtl"> در Go برخلاف برخی زبان‌ها مانند Java، مفهوم رسمی و مستقیمی به نام <b>Reference Type</b> وجود ندارد. با این حال، برخی تایپ‌ها رفتارهایی شبیه Reference Type دارند؛ یعنی مقدار آن‌ها می‌تواند به داده‌ای در حافظه اشاره کند یا داده‌ای را به صورت اشتراکی مدیریت کند. </p> <ul dir="ltr"> <li>Pointer</li> <li>Slice</li> <li>Map</li> <li>Channel</li> <li>Function</li> </ul> <p dir="rtl"> این یک دسته‌بندی مفهومی است و اصطلاح رسمی زبان Go برای تعریف این تایپ‌ها نیست. </p>

<h2 dir="rtl"> 🌱 3: تایپ‌های Aggregate در Go کدام هستند؟</h2> <p dir="rtl"> Aggregate Typeها تایپ‌هایی هستند که می‌توانند چند مقدار را درون خود نگهداری کنند. </p> <ul dir="ltr"> <li>Array</li> <li>Struct</li> </ul> <p dir="rtl"> برای مثال: </p>

```go
type User struct {
    Name string
    Age  int
}

var numbers [3]int
var user User
```
<h2 dir="rtl"> 🌱 4: تفاوت Value و Pointer در Go چیست؟</h2> <p dir="rtl"> در Go بیشتر تایپ‌ها به صورت Value منتقل می‌شوند. زمانی که یک Value را به Function ارسال می‌کنیم، مقدار آن Copy می‌شود. </p>

```go
func change(x int) {
    x = 20
}

x := 10
change(x)

fmt.Println(x) // 10
```
<p dir="rtl"> اما اگر Pointer ارسال کنیم، Function می‌تواند مقدار اصلی را تغییر دهد: </p>

```go
func change(x *int) {
    *x = 20
}

x := 10
change(&x)

fmt.Println(x) // 20
```
<h2 dir="rtl"> 🌱 5: زبان Go از چه قابلیت‌هایی پشتیبانی نمی‌کند؟</h2> <p dir="rtl"> Go عمداً برخی قابلیت‌های رایج در زبان‌های دیگر را پشتیبانی نمی‌کند یا آن‌ها را به شکل متفاوتی ارائه می‌دهد. </p> <ul dir="ltr"> <li>Classical type inheritance</li> <li>Operator overloading</li> <li>Method overloading</li> <li>Pointer arithmetic</li> </ul> <p dir="rtl"> در Go به جای Inheritance معمولاً از Composition، Embedding و Interface استفاده می‌شود. </p>
<h2 dir="rtl"> 🌱 6: تفاوت Type Alias و Defined Type در Go چیست؟</h2> <p dir="rtl"> در Go می‌توان با استفاده از <code>type</code> یک Type جدید تعریف کرد یا یک Alias برای Type موجود ساخت. </p> <p dir="rtl"> <b>Defined Type:</b> </p>

```go
type UserID int
```
<p dir="rtl"> در این حالت <code>UserID</code> یک Type جدید است و با <code>int</code> یکسان نیست. </p> <p dir="rtl"> <b>Type Alias:</b> </p>

```go
type UserID = int
```
<p dir="rtl"> در این حالت <code>UserID</code> فقط نام دیگری برای همان <code>int</code> است و Type جدیدی ایجاد نمی‌شود. </p>
<h2 dir="rtl"> 🌱 7: چه تفاوتی میان make و new در Go وجود دارد؟</h2> <p dir="rtl"> <code>new</code> یک Pointer به Zero Value تایپ موردنظر برمی‌گرداند. </p>

```go
p := new(int)

fmt.Println(*p) // 0
```
<p dir="rtl"> اما <code>make</code> برای ایجاد و آماده‌سازی Slice، Map و Channel استفاده می‌شود. </p>

```go
s := make([]int, 10)

m := make(map[string]int)

ch := make(chan int, 10)
```
<p dir="rtl"> بنابراین: </p> <ul dir="ltr"> <li><code>new(T)</code> → <code>*T</code></li> <li><code>make(T)</code> → مقدار آماده استفاده از نوع Slice، Map یا Channel</li> </ul>
<h2 dir="rtl"> 🌱 8: Method Receiver چیست و تفاوت Pointer Receiver و Value Receiver چیست؟</h2> <p dir="rtl"> Receiver مشخص می‌کند که یک Method متعلق به چه Typeای است. </p> <p dir="rtl"> در Value Receiver یک Copy از Receiver در اختیار Method قرار می‌گیرد. </p>

```go
type User struct {
    Name string
}

func (u User) ChangeName(name string) {
    u.Name = name
}
```
<p dir="rtl"> در Pointer Receiver، Method به Object اصلی دسترسی دارد و می‌تواند State آن را تغییر دهد. </p>

```go
func (u *User) ChangeName(name string) {
    u.Name = name
}
```