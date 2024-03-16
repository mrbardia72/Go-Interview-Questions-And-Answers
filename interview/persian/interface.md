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

 <h2  dir="rtl"> 🌱  اینترفیس Embedding چیست </h2>  
 <p  dir="ltr">
1- In addition to defining standalone interfaces, Go also allows you to embed interfaces within other interfaces. 
This is called interface embedding, and it provides a powerful way to compose interfaces. 

2- Interface embedding, also known as interface inheritance, is a mechanism in which one interface is embedded within 
another interface. This allows the embedding interface to inherit the methods of the embedded interface, effectively 
extending its behavior.

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

type PrinterScannerImpl struct {}

func (ps PrinterScannerImpl) Print() {
    fmt.Println("Printing")
}

func (ps PrinterScannerImpl) Scan() {
    fmt.Println("Scanning")
}

func main() {
    ps := PrinterScannerImpl{}
    PrintAndScan(ps)
}

func PrintAndScan(ps PrinterScanner) {
    ps.Print()
    ps.Scan()
}
```
</p>

---

 <h2  dir="rtl"> 🌱  اینترفیس Composition چیست </h2>  
 <p  dir="ltr">
1- In addition to interface embedding, Go also supports interface composition. 
Interface composition allows you to create
a new interface by combining two or more existing interfaces.

2- Interface composition involves creating a new interface by combining multiple existing interfaces. 
This approach allows you to define a new interface that incorporates the behavior of the individual interfaces it 
comprises. In other words, it is a way of combining multiple interfaces to create a more specific or comprehensive 
interface.

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

type FileReaderWriter struct {
    filename string
}

func (f FileReaderWriter) Read(p []byte) (n int, err error) {
    // read from file
    return len(p), nil
}

func (f FileReaderWriter) Write(p []byte) (n int, err error) {
    // write to file
    return len(p), nil
}

func main() {
    f := FileReaderWriter{"myfile.txt"}
    ReadAndWrite(f)
}

func ReadAndWrite(rw ReadWriter) {
    // read and write using the same interface
    data := make([]byte, 1024)
    rw.Read(data)
    rw.Write(data)
}
```

 </p>
---

 <h2  dir="rtl"> 🌱 برای درک بهتر نحوه استفاده از رابط ها در Go، بیایید نگاهی به چند نمونه از بسته های محبوب Go بیندازیم.  </h2>  
 <p  dir="ltr">
1. http.Handler interface

```go
type Handler interface {
    ServeHTTP(ResponseWriter, *Request)
}
```

2. io.Reader and io.Writer interfaces

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}
```

3. database/sql/driver interfaces

```go
type Driver interface {
    Open(name string) (Conn, error)
}
```

4. sort.Interface interface

```go
type Interface interface {
    Len() int
    Less(i, j int) bool
    Swap(i, j int)
}
```

5. flag.Value interface

```go
type Value interface {
    String() string
    Set(string) error
}
```

 </p>

---

 <h2  dir="rtl"> 🌱 فرق بین interface embedding و Interface composition در چیست  </h2>  
 <p  dir="ltr">
1- Interface Embedding:

Interface embedding refers to embedding one interface into another interface.

In Go, you can embed an interface as a method set within another interface, allowing the embedding interface to inherit the methods of the embedded interface.

The embedding interface gains all the methods of the embedded interface, and it can also define additional methods.

The embedding interface acts as a superset of the embedded interface, providing a way to extend or specialize the behavior of the embedded interface.

The embedded interface’s methods can be directly accessed through the embedding interface, without the need for explicit forwarding or delegation. 

2- Interface Composition:

Interface composition refers to combining multiple interfaces into a single interface.

With interface composition, you define a new interface that includes multiple existing interfaces as embedded types.

The composed interface combines the method sets of the embedded interfaces, creating a unified set of methods.

The composed interface can be used to interact with any object that implements all the embedded interfaces.

Interface composition provides a way to define more specific, higher-level interfaces by combining existing interfaces.

3- Differences:

Interface composition involves combining multiple interfaces to create a new interface with a specific set of behaviors.

Interface embedding is a way of inheriting methods from an embedded interface and extending it with additional methods.

Interface composition creates a new interface that includes the behaviors of the composed interfaces, while interface embedding
allows one interface to inherit the methods of another interface.

Interface composition is typically used when you want to define a higher-level interface that combines multiple 
behaviors, while interface embedding is used to extend an existing interface with additional methods.

 </p>

---
 <h2  dir="rtl"> 🌱   </h2>  
 <p  dir="rtl">
جواب 
 </p>

---