<h2 dir="rtl"> 🌱 1: چه زمانی باید از Pointer استفاده کنیم؟</h2>

<p dir="rtl">
استفاده از Pointer در Go معمولاً در چند شرایط مهم کاربرد دارد.
</p>

<p dir="rtl">
<b>1. زمانی که می‌خواهیم مقدار اصلی را تغییر دهیم</b>
</p>

```go
func updateAge(age *int) {
    *age = 30
}

age := 20
updateAge(&age)

fmt.Println(age) // 30
```
<p dir="rtl"> <b>2. زمانی که نمی‌خواهیم یک مقدار بزرگ را Copy کنیم</b> </p> <p dir="rtl"> اگر یک Struct بزرگ باشد، ارسال Pointer می‌تواند از Copy شدن غیرضروری داده جلوگیری کند. البته استفاده از Pointer همیشه سریع‌تر نیست و باید با Benchmark و Escape Analysis بررسی شود. </p> <p dir="rtl"> <b>3. زمانی که به مفهوم نبودن مقدار نیاز داریم</b> </p> <p dir="rtl"> Pointer می‌تواند مقدار <code>nil</code> داشته باشد و بنابراین می‌توان بین «مقداری وجود ندارد» و «مقدار صفر» تفاوت ایجاد کرد. </p>

```go
var age *int

if age == nil {
    fmt.Println("age is not set")
}
```
<h2 dir="rtl"> 🌱 2: آیا کپی کردن Pointer همیشه سریع‌تر از کپی کردن Value است؟</h2> <p dir="rtl"> خیر. این تصور که کپی کردن Pointer همیشه سریع‌تر از کپی کردن Value است، صحیح نیست. </p> <p dir="rtl"> کپی کردن یک Pointer معمولاً شامل کپی کردن یک مقدار آدرس است، اما استفاده از Pointer می‌تواند پیامدهای دیگری مانند Escape شدن داده به Heap، کاهش Cache Locality و افزایش فشار روی Garbage Collector داشته باشد. </p> <p dir="rtl"> بنابراین برای تصمیم‌گیری درباره Performance بهتر است از Benchmark و Escape Analysis استفاده کنیم: </p>

```go
go test -bench=.
go build -gcflags="-m" .
```
<p dir="rtl"> در نتیجه نباید یک قانون کلی مانند «Pointer همیشه بهتر است» در نظر گرفت. </p>
<h2 dir="rtl"> 🌱 3: تفاوت Pointer و Value Receiver چیست؟</h2> <p dir="rtl"> در Value Receiver یک Copy از Value به Method داده می‌شود. </p>

```go
func (u User) ChangeName(name string) {
    u.Name = name
}
```
<p dir="rtl"> در Pointer Receiver، Pointer به Object اصلی در اختیار Method قرار می‌گیرد. </p>

```go
func (u *User) ChangeName(name string) {
    u.Name = name
}
```
<p dir="rtl"> بنابراین زمانی که Method باید State مربوط به Object را تغییر دهد، معمولاً Pointer Receiver مورد استفاده قرار می‌گیرد. </p> 