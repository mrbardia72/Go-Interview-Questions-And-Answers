## What's the difference between `//go:build` and `// +build` directives?
#### Go 1.18
* The new directive `//go:build` is now preferred and the toolchain will actively remove old directives; as mentioned in Go 1.18 release notes:

  * In Go 1.18, go fix now removes the now-obsolete `// +build` lines in modules declaring go 1.18 or later in their go.mod files.

Due to the above, if you attempt to build a module with `go.mod` at 1.17 or lower that requires a dependency at 1.18 or above, the build may fail if the dependency is missing `// +build` lines.

#### Go 1.17
`//go:build` is the new conditional compilation directive used to specify build constraints. It was introduced in Go 1.17.

It is meant to replace the old `// +build` directives; the use case is still same: it "lists the conditions under which a file should be included in the package". The new syntax brings a few key improvements:

* consistency with other existing Go directives and pragmas, e.g. `//go:generate`
* support for standard boolean expression, e.g. `//go:build foo && bar`, whereas the old `// +build` comment has less intuitive syntax. For example AND was expressed with commas `// +build foo,bar` and OR with spaces `// +build foo bar`
* it's supported by `go fmt`, which will automatically fix incorrect placement of the directive in source files, thus avoiding common mistakes as not leaving a blank line between the directive and the package statement.

The two build directives will coexist over a few Go releases in order to ensure a smooth transition, as outlined in the relevant proposal document (in the quote below N is 17, emphasis mine):

#### Go 1.N would start the transition. In Go 1.N:

* Builds will start preferring `//go:build` lines for file selection. If there is no `//go:build` in a file, then any `// +build` lines still apply.

* Builds will no longer fail if a Go file contains `//go:build` without `// +build`.

* Builds will fail if a Go or assembly file contains `//go:build` too late in the file. `Gofmt` will move misplaced `//go:build` and `// +build` lines to their proper location in the file.

* `Gofmt` will format the expressions in `//go:build` lines using the same rules as for other Go boolean expressions (spaces around all && and || operators).

* If a file contains only `// +build` lines, `gofmt` will add an equivalent `//go:build` line above them.

* If a file contains both `//go:build` and `// +build` lines, `gofmt` will consider the `//go:build` the source of truth and update the `// +build` lines to match, preserving compatibility with earlier versions of Go. `Gofmt` will also reject `//go:build` lines that are deemed too complex to convert into `// +build `format, although this situation will be rare. (Note the “If” at the start of this bullet. `Gofmt` will not add `// +build `lines to a file that only has `//go:build`.)

* The buildtags check in go vet will add support for `//go:build` constraints. It will fail when a Go source file contains `//go:build` and `// +build` lines with different meanings. If the check fails, one can run` gofmt -w`.

* The buildtags check will also fail when a Go source file contains `//go:build` without `// +build `and its containing module has a go line listing a version before Go 1.N. If the check fails, one can add any `// +build` line and then run `gofmt -w`, which will replace it with the correct ones. Or one can bump the `go.mod` go version to Go 1.N.

## What does go build build? (go build vs. go install)
#### For packages
* `go build`   builds your package then discards the results.
* `go install` builds then installs the package in your $GOPATH/pkg directory.
#### For commands (package main)
* `go build`   builds the command and leaves the result in the current working directory.
* `go install` builds the command in a temporary directory then moves it to $GOPATH/bin.