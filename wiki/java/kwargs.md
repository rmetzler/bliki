# Keyword Arguments in Java

## What

Java arguments are traditionally passed by position:

    void foo(int x, int y, int z)

matches the call

    foo(1, 2, 3)

and assigns `1` to `x`, `2` to `y`, and `3` to `z` in the resulting
activation. Keyword arguments assign values to formal parameters by matching
the parameter's name, instead.

## Why

Fuck the builder pattern, okay? Patterns like

    Response r = Response
        .status(200)
        .entity(foo)
        .header("X-Plane", "Amazing")
        .build();

(from JAX-RS) mean the creation and maintenance of an entire separate type
just to handle arbitrary ordering and presence/absence of options. Ordering
can be done using keywords; presence/absence can be done by providing one
method for each legal combination of arguments (or by adding optional
arguments to Java).

The keyword-argument version would be something like

    Response r = new Response(
        .status = 200,
        .entity = foo,
        .headers = Arrays.asList(Header.of("X-Plane", "Amazing"))
    );

and the `ResponseBuilder` class would not need to exist at all for this case.
(There are others in JAX-RS that would still make `ResponseBuilder` mandatory,
but the use case for it gets much smaller.)

As an added bonus, the necessary class metadata to make this work would also
allow reflective frameworks such as Spring to make sensible use of the
parameter names:

    <bean class="com.example.Person">
        <constructor-arg name="name" value="Erica McKenzie" />
    </bean>

## Other Languages

Python, most recently:

    def foo(x, y, z):
        pass
    
    foo(z=3, x=1, y=2)

Smalltalk (and ObjectiveC) use an interleaving convention that reads very much
like keyword arguments:

    Point atX: 5 atY: 8

## Challenges

* Minimize changes to syntax.
    * Make keyword arguments unambiguous.
* Minimize changes to bytecode spec.

## Proposal

Given a method definition

    void foo(int x, int y, int z)

Allow calls written as

    foo(
        SOME-SYNTAX(x, EXPR),
        SOME-SYNTAX(y, EXPR),
        SOME-SYNTAX(z, EXPR)
    )

`SOME-SYNTAX` is a production that is not already legal at that point in Java,
which is a surprisingly frustrating limitation. Constructs like

    foo(x = EXPR, y = EXPR, z = EXPR)

are already legal (assignment is an expression) and already match positional
arguments.

Keyword arguments match the name of the formal argument in the method
declaration. Passing a keyword argument that does not match a formal argument
is a compilation error.

Calls can mix keyword arguments and positional arguments, in the following
order:

1. Positional arguments.
2. Varargs positional arguments.
3. Keyword arguments.

Passing the same argument as both a positional and a keyword argument is a
compilation error.

Call sites must satisfy every argument the method/constructor has (i.e., this
doesn't imply optional arguments). This makes implementation easy and
unintrusive: the compiler can implement keyword arguments by transforming them
into positional arguments. Reflective calls (`Method.invoke` and friends) can
continue accepting arguments as a sequence.

The `Method` class would expose a new method:

    public List<String> getArgumentNames()

The indexes in `getArgumentNames` match the indexes in `getArgumentTypes` and
related methods.

Possibilities for syntax:

* `foo(x := 5, y := 8, z := 2)` - `:=` is never a legal sequence of tokens in
  Java. Introduces one new operator-like construct; the new sequence `:=`
  “looks like” assignment, which is a useful mnemonic.

* `foo(x ~ 5, y ~ 8, z ~ 2)` - `~` is not a binary operator and this is never
  legal right now. This avoids introducing new operators, but adds a novel
  interpretation to an existing unary operator that's not related to its
  normal use.

* `foo(.x = 5, .y = 8, .z = 2)` - using `=` as the keyword binding feels more
  natural. Parameter names must be legal identifiers, which means the leading
  dot is unambiguous. This syntax is not legal anywhere right now (the dot
  always has a leading expression). The dot is a “namespace” symbol already.

To support this, the class file format will need to record the names of
parameters, not just their order. This is a breaking change, and generated
names will need to be chosen for existing class files. (This may be derivable
from debug information, where present.)


## Edge Cases

* Mixed positional and keyword arguments.
    * Collisions (same argument passed by both) are, I think, detectable at
      compile time. This should be an error.
* Inheritance. It is legal for a superclass to define `foo(a, b)` and for
  subclasses to override it as `foo(x, y)`. Which argument names do you use
  when?
* Varargs.
