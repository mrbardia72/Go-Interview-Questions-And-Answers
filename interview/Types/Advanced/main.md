<h2 dir="rtl"> 🌱 1: تفاوت Interface Nil و Nil Pointer چیست؟</h2>

<p dir="rtl">
یک Interface زمانی واقعاً <code>nil</code> است که هم Type و هم Value آن nil باشند.
</p>

```go
var p *int = nil
var x interface{} = p
fmt.Println(x == nil) // false
```
<p dir="rtl"> در اینجا Interface مقدار <code>nil</code> نیست؛ زیرا داخل Interface یک Type یعنی <code>*int</code> وجود دارد، حتی اگر Value آن nil باشد. </p>
<h2 dir="rtl"> 🌱 2: Type Assertion در Go چیست؟</h2> 
<p dir="rtl"> Type Assertion برای به‌دست آوردن Type واقعی یک مقدار موجود در Interface استفاده می‌شود. </p>

```go
var value interface{} = "hello"

s, ok := value.(string)

if ok {
    fmt.Println(s)
}
‍‍```
<p dir="rtl"> استفاده از فرم دوم باعث می‌شود در صورت اشتباه بودن Type، برنامه Panic نکند. </p>
<h2 dir="rtl"> 🌱 3: Type Switch در Go چیست؟</h2> 
<p dir="rtl"> Type Switch زمانی استفاده می‌شود که بخواهیم بر اساس Type واقعی یک مقدار Interface رفتار متفاوتی داشته باشیم. </p>

```go
func printValue(v interface{}) {
    switch value := v.(type) {
    case string:
        fmt.Println("string:", value)

    case int:
        fmt.Println("int:", value)

    case bool:
        fmt.Println("bool:", value)

    default:
        fmt.Println("unknown type")
    }
}
```
<h2 dir="rtl"> 🌱 4: چرا Go از Inheritance کلاسیک استفاده نمی‌کند؟</h2> <p dir="rtl"> Go مدل کلاسیک Inheritance را مانند Java یا C++ ارائه نمی‌کند و بیشتر بر Composition و Interfaceها تأکید دارد. </p> <p dir="rtl"> Composition باعث می‌شود Typeها بتوانند رفتار و داده‌های Typeهای دیگر را از طریق Embedding یا نگهداری به عنوان Field استفاده کنند، بدون اینکه یک سلسله‌مراتب پیچیده از کلاس‌ها ایجاد شود. </p>

```go
type Engine struct{}

func (Engine) Start() {
    fmt.Println("engine started")
}

type Car struct {
    Engine
}
```
<h2 dir="rtl"> 🌱 5: چگونه یک Package اختصاصی در Go ایجاد کنیم؟</h2> <p dir="rtl"> برای ایجاد یک Package کافی است فایل‌های Go مربوط به آن را در یک Directory قرار دهیم و نام Package را در ابتدای فایل مشخص کنیم. </p>

```go
package calculator

func Add(a, b int) int {
    return a + b
}
```
<p dir="rtl"> سپس می‌توان آن را Import کرد: </p>

```go
import "example.com/project/calculator"

result := calculator.Add(10, 20)
```
<p dir="rtl"> برای قابل دسترس بودن یک Identifier از Package دیگر، نام آن باید با حرف بزرگ شروع شود. </p>
<h2 dir="rtl"> 🌱 6: Error Handling در Go چگونه انجام می‌شود؟</h2> <p dir="rtl"> در Go معمولاً Error به عنوان Return Value برگردانده می‌شود و Caller وظیفه بررسی آن را دارد. </p>

```go
result, err := DoSomething()

if err != nil {
    return err
}
```
<p dir="rtl"> برای ایجاد Error ساده می‌توان از <code>errors.New</code> استفاده کرد. </p>

```go
err := errors.New("user not found")
```
<p dir="rtl"> همچنین می‌توان Custom Error Type ایجاد کرد. </p>

```go
type ValidationError struct {
    Field string
    Msg   string
}

func (e ValidationError) Error() string {
    return e.Field + ": " + e.Msg
}
```
<h2 dir="rtl"> 🌱 7: Dependency Management در Go چگونه انجام می‌شود؟</h2> <p dir="rtl"> Go برای مدیریت Dependencyها از Go Modules استفاده می‌کند. </p>

```go
go mod init example.com/myproject
```
<p dir="rtl"> برای مرتب‌سازی Dependencyها: </p>

```go
go mod tidy
```
<p dir="rtl"> فایل <code>go.mod</code> اطلاعات Module و Dependencyها را نگهداری می‌کند و <code>go.sum</code> نیز Checksumهای Dependencyها را ثبت می‌کند. </p>
<h2 dir="rtl"> 🌱 8: defer در Go چیست؟</h2> <p dir="rtl"> <code>defer</code> باعث می‌شود یک Function Call تا زمان خروج از Function فعلی به تعویق بیفتد. </p>

```go
file, err := os.Open("data.txt")
if err != nil {
    return err
}

defer file.Close()
```
<p dir="rtl"> اگر چند defer داشته باشیم، آن‌ها به صورت LIFO اجرا می‌شوند؛ یعنی آخرین defer زودتر اجرا می‌شود. </p>

```go
defer fmt.Println("first")
defer fmt.Println("second")

// second
// first
```
<h2 dir="rtl"> 🌱 9: Table-Driven Test چیست؟</h2> <p dir="rtl"> Table-Driven Testing یکی از الگوهای رایج تست‌نویسی در Go است که در آن Test Caseها در قالب یک جدول تعریف می‌شوند و یک منطق مشترک روی آن‌ها اجرا می‌شود. </p>

```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name string
        a    int
        b    int
        want int
    }{
        {
            name: "positive numbers",
            a:    2,
            b:    3,
            want: 5,
        },
        {
            name: "zero",
            a:    0,
            b:    3,
            want: 3,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := Add(tt.a, tt.b)

            if got != tt.want {
                t.Fatalf("got %d, want %d", got, tt.want)
            }
        })
    }
}
```
<p dir="rtl"> مزیت اصلی این روش کاهش Duplicate Code و ساده‌تر شدن اضافه کردن Test Caseهای جدید است. </p>
<h2 dir="rtl"> 🌱 10: تفاوت *string و sql.NullString چیست؟</h2> <p dir="rtl"> <code>*string</code> یک Pointer به String است و می‌تواند <code>nil</code> باشد. </p>

```go
var name *string

if name == nil {
    fmt.Println("name is NULL")
}
```
<p dir="rtl"> اما <code>sql.NullString</code> برای نمایش مقدار Nullable در SQL طراحی شده است. </p>

```go
type NullString struct {
    String string
    Valid  bool
}
```
<p dir="rtl"> در اینجا <code>Valid</code> مشخص می‌کند که مقدار از نظر SQL معتبر و غیر NULL است یا خیر. </p> 
