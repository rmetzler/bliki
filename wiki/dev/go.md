# I Do Not Like Go

I use Go at my current day job. I've gotten pretty familiar with it. I do not like it, and its popularity is baffling to me.

## Developer Ergonomics

I've never met a language lead so openly hostile to the idea of developer ergonomics. To pick one example, Rob Pike has been repeatedly and openly hostile to any discussion of syntax highlighting on the Go playground. In response to reasonably-phrased user questions, his public answers have been disdainful and disrespectful:

> Gofmt was written to reduce the number of pointless discussions about code formatting. It succeeded admirably. I'm sad to say it had no effect whatsoever on the number of pointless discussions about syntax highlighting, or as I prefer to call it, spitzensparken blinkelichtzen.

From a [2012 Go-Nuts thread](http://grokbase.com/t/gg/golang-nuts/12asys9jn4/go-nuts-go-playground-syntax-highlighting), and again:

> Syntax highlighting is juvenile. When I was a child, I was taught arithmetic using colored rods (http://en.wikipedia.org/wiki/Cuisenaire_rods). I grew up and today I use monochromatic numerals.

Clearly nobody Rob cares about has ever experienced synaesthesia, dyslexia, or poor eyesight. Rob's resistance to the idea has successfully kept Go's official site and docs highlighting-free as of this writing.

The Go team is not Rob Pike, but they've shared his attitude towards ergonomics in other ways. In a discussion of [union/sum types](https://github.com/golang/go/issues/19412), user ianlancetaylor rejects the request out of hand by specifically identifying an ergonomic benefit and writing it off as too minor to be worth bothering:

> This has been discussed several times in the past, starting from before the open source release. The past consensus has been that sum types do not add very much to interface types. Once you sort it all out, what you get in the end if an interface type where the compiler checks that you've filled in all the cases of a type switch. That's a fairly small benefit for a new language change.

This attitude is at odds with opinions about union types in other languages. JWZ, criticising Java in 2000, wrote:

> Similarly, I think the available idioms for simulating enum and :keywords fairly lame. (There's no way for the compiler to issue that life-saving warning, ``enumeration value `x' not handled in switch'', for example.)

The Java team took criticism in this vein to heart, and Java can now emit this warning for `switch`es over `enum` types. Other languages - including both modern languages such as Rust, Scala, Elixir, and friends, as well as Go's own direct ancestor, C - similarly warn where possible. Clearly, these kinds of warning are useful, but to the Go team, developer comfort is not important enough to merit consideration.

## Politics

No, not the mailing-lists-and-meetups kind. A deeper and more interesting kind.

Go is, like every language, a political vehicle. It embodies a particular set of beliefs about how software should be written and organized. In Go's case, the language embodies an extremely rigid caste hierarchy of "skilled programmers" and "unskilled programmers," enforced by the language itself.

On the unskilled programmers side, the language forbids features considered "too advanced." Go has no generics, no way to write higher-order functions that generalize across more than a single concrete type, and extremely stringent prescriptive rules about the presence of commas, unused symbols, and other infelicities that might occur in ordinary code. This is the world in which Go programmers live - one which is, if anything, even _more_ constrained than Java 1.4 was.

On the skilled programmers side, programmers are trusted with those features, and can expose things built with them to other programmers on both sides of the divide. The language implementation contains generic functions which cannot be implemented in Go, and which satisfy typing relationships the language simply cannot express. This is the world in which the Go _implementors_ live.

I can't speak for Go's genesis within Google, but outside of Google, this underanalysed political stance dividing programmers into "trustworthy" and "not" underlies many arguments about the language.

## Packaging and Distribution of Go Code

`go get` is a disappointing abdication of responsibility. Packaging boundaries are communications boundaries, and the Go team's response of "vendor everything" amounts to refusing to help developers communicate with one another about their code.

I can respect the position the Go team has taken, which is that it's not their problem, but that puts them at odds with every other major language. Considering the disastrous history of attempts at package management for C libraries and the existence of Autotools as an example of how this can go very wrong over a long-enough time scale, it's very surprising to see a language team in this century washing their hands of the situation.

## GOPATH

The use of a single monolithic path for all sources makes version conflicts between dependencies nearly unavoidable. The `vendor` workaround partially addresses the problem, at the cost of substantial repository bloat and non-trivial linkage changes which can introduce bugs if a vendored and a non-vendored copy of the same library are linked in the same application.

Again, the Go team's "not our problem" response is disappointing and frustrating.

## Error Handling in Go

The standard Go approach to operations which may fail involves returning multiple values (not a tuple; Go has no tuples) where the last value is of type `error`, which is an interface whose `nil` value means “no error occurred.”

Because this is a convention, it is not representable in Go's type system. There is no generalized type representing the result of a fallible operation, over which one can write useful combining functions. Furthermore, it's not rigidly adhered to: nothing other than good sense stops a programmer from returning an `error` in some other position, such as in the middle of a sequence of return values, or at the start - so code generation approaches to handling errors are also fraught with problems.

It is not possible, in Go, to compose fallible operations in any way less verbose than some variation on
```go
    a, err := fallibleOperationA()
    if err != nil {
        return nil, err
    }

    b, err := fallibleOperationB(a)
    if err != nil {
        return nil, err
    }

    return b, nil
```

In other languages, this can variously be expressed as

```java
    a = fallibleOperationA()
    b = fallibleOperationB(a)
    return b
```

in languages with exceptions, or as

```javascript
    return fallibleOperationA()
        .then(a => fallibleOperationB(a))
        .result()
```

in languages with abstractions that can operate over values with cases.

This has real impact: code which performs long sequences of fallible operations expends a substantial amount of typing effort to write (even with editor support generating the branches), and a substantial amount of cognitive effort to read. Style guides help, but mixing styles makes it worse. Consider:

```go
    a, err := fallibleOperationA()
    if err != nil {
        return nil, err
    }

    if err := fallibleOperationB(a); err != nil {
        return nil, err
    }

    c, err := fallibleOperationC(a)
    if err != nil {
        return nil, err
    }

    fallibleOperationD(a, c)

    return fallibleOperationE()
```

God help you if you nest them, or want to do something more interesting than passing an error back up the stack.
