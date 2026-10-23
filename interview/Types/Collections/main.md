
<h2 dir="rtl"> 🌱 1: تفاوت Array و Slice در Go چیست؟</h2>

<p dir="rtl">
Array دارای اندازه ثابت است و اندازه آن بخشی از Type محسوب می‌شود.
</p>

```go
var a [3]int
var b [4]int
```
<p dir="rtl"> در این مثال <code>[3]int</code> و <code>[4]int</code> دو Type متفاوت هستند. </p> <p dir="rtl"> Slice اندازه ثابت ندارد و یک Descriptor برای دسترسی به بخشی از یک Array است. </p>

```go
s := []int{1, 2, 3}
s = append(s, 4)
```
<p dir="rtl"> یک Slice معمولاً شامل Pointer، Length و Capacity است. </p>
<h2 dir="rtl"> 🌱 2: تفاوت Map و Struct در Go چیست؟</h2> <p dir="rtl"> Struct برای تعریف یک ساختار مشخص و Type-safe با Fieldهای مشخص استفاده می‌شود. </p>

```go
type User struct {
    Name string
    Age  int
}
```
<p dir="rtl"> Map مجموعه‌ای از Key/Valueهاست. </p>

```go
users := map[string]int{
    "Ali":  20,
    "Reza": 30,
}
```
<p dir="rtl"> Struct زمانی مناسب است که ساختار داده مشخص باشد، در حالی که Map برای داده‌های Key/Value مناسب‌تر است. </p>
<h2 dir="rtl"> 🌱 3: Zero Value در Array، Slice، Map و Struct چه تفاوتی دارد؟</h2> <p dir="rtl"> Array و Struct دارای Zero Value واقعی برای اعضای خود هستند. </p>

```go
var a [3]int
var u User
```
<p dir="rtl"> اما Slice و Map در حالت Zero Value برابر <code>nil</code> هستند. </p>

```go
var s []int
var m map[string]int

fmt.Println(s == nil) // true
fmt.Println(m == nil) // true
```
<p dir="rtl"> Slice nil قابل استفاده در برخی عملیات مانند <code>append</code> است، اما Map nil قابل Write نیست. </p>

```go
var s []int
s = append(s, 10)

var m map[string]int
// m["name"] = "Ali" // panic
```