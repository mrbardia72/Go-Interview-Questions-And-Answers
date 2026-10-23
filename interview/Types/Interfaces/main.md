<h2 dir="rtl"> 🌱 1: چرا باید از Interface استفاده کنیم؟</h2>

<p dir="rtl">
Interfaceها در Go برای تعریف رفتار موردنیاز و کاهش وابستگی مستقیم بین اجزای سیستم استفاده می‌شوند.
</p>

<ul dir="rtl">
<li>کاهش Coupling</li>
<li>امکان استفاده از چند Implementation مختلف</li>
<li>ساده‌تر شدن Unit Testing</li>
<li>استفاده از Mock و Fake</li>
<li>تعریف رفتار به جای وابستگی به Implementation</li>
</ul>

---

<h2 dir="rtl"> 🌱 2: آیا در Go می‌توان از Polymorphism استفاده کرد؟</h2>

<p dir="rtl">
بله. یکی از روش‌های اصلی پیاده‌سازی Polymorphism در Go استفاده از Interface است.
</p>

```go
type Speaker interface {
    Speak()
}

type Dog struct{}

func (Dog) Speak() {
    fmt.Println("Woof")
}

type Cat struct{}

func (Cat) Speak() {
    fmt.Println("Meow")
}

func MakeSpeak(s Speaker) {
    s.Speak()
}
```

<h2 dir="rtl"> 🌱 3: Interface در Go چیست؟</h2> <p dir="rtl"> Interface یک Type است که مجموعه‌ای از Methodها را تعریف می‌کند. </p>

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}
```
<p dir="rtl"> هر Typeای که تمام Methodهای موردنیاز Interface را داشته باشد، به صورت Implicit آن Interface را پیاده‌سازی می‌کند. </p> <p dir="rtl"> برای پیاده‌سازی Interface نیازی به عبارتی مانند <code>implements</code> وجود ندارد. </p>
<h2 dir="rtl"> 🌱 4: Interface Embedding چیست؟</h2> <p dir="rtl"> در Go می‌توان یک Interface را داخل Interface دیگری Embed کرد. </p>

```go
type Printer interface {
    Print()
}

type Scanner interface {
    Scan()
}

type PrinterScanner interface {
    Printer
    Scanner
}
```
<p dir="rtl"> در این حالت Methodهای Interfaceهای داخلی بخشی از Method Set مربوط به Interface بیرونی می‌شوند. </p>
<h2 dir="rtl"> 🌱 5: Interface Composition چیست؟</h2> <p dir="rtl"> Interface Composition یعنی ساخت یک Interface جدید از ترکیب چند رفتار مختلف. </p>

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

type ReadWriter interface {
    Reader
    Writer
}
```
<p dir="rtl"> در Go معمولاً Interface Composition از طریق Interface Embedding انجام می‌شود. </p>
<h2 dir="rtl"> 🌱 6: تفاوت Interface Embedding و Interface Composition چیست؟</h2> <p dir="rtl"> این دو مفهوم بسیار به یکدیگر مرتبط هستند. </p> <p dir="rtl"> <b>Interface Embedding</b> یعنی قرار دادن یک Interface داخل Interface دیگر. </p> <p dir="rtl"> <b>Interface Composition</b> مفهوم بزرگ‌تری است که به ساخت یک Interface جدید از ترکیب چند رفتار اشاره دارد. </p> <p dir="rtl"> در Go، Embedding یکی از روش‌های اصلی برای انجام Interface Composition است. </p>
<h2 dir="rtl"> 🌱 7: چند Interface مهم در کتابخانه استاندارد Go کدام هستند؟</h2> <p dir="rtl"> چند Interface بسیار مهم در Standard Library عبارت‌اند از: </p> <p dir="rtl"><b>io.Reader</b></p>

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}
```
<p dir="rtl"><b>io.Writer</b></p>

```go
type Writer interface {
    Write(p []byte) (n int, err error)
}
```
<p dir="rtl"><b>http.Handler</b></p>

```go
type Handler interface {
    ServeHTTP(ResponseWriter, *Request)
}
```
<p dir="rtl"><b>sort.Interface</b></p>

```go
type Interface interface {
    Len() int
    Less(i, j int) bool
    Swap(i, j int)
}
```
<p dir="rtl"><b>flag.Value</b></p>

```go
type Value interface {
    String() string
    Set(string) error
}
```