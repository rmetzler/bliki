# A New Kind of Java

Java 8 is almost here. You can [play with the early access
previews](http://jdk8.java.net/download.html) right now, and I think you
should, even if you don't like Java very much. There's so much _potential_ in
there.

## The "One More Thing"

The Java 8 release comes with a slew of notable library improvements: the new
[`java.time`](http://openjdk.java.net/jeps/150) package, designed by the folks
behind the extremely capable Joda time library; [reflective
access](http://openjdk.java.net/jeps/118) to parameter names; [Unicode
6.2](http://openjdk.java.net/jeps/133) support; numerous others. But all of
these things are dwarfed by the "one last thing":

**Lambdas**.

## Ok, So..?

Here's the thing: all of the "modern" languages that see regular use - C#,
Python, Ruby, the various Lisps including Clojure, and Javascript - have
language features allowing easy creation and use of one-method values. In
Python, that's any object with a `__call__` method (including function
objects); in Ruby, it's blocks; in Javascript, it's `function() {}`s. These
features allow _computation itself_ to be treated as a value and passed
around, which in turn provides a very powerful and succinct mechanism for
composing features.

Java's had the "use" side down for a long time; interfaces like `Runnable` are
a great example of ways to expose "function-like" or "procedure-like" types to
the language without violating Java's bureaucratic attitude towards types and
objects. However, the syntax for creating these one-method values has always
been so verbose and awkward as to discourage their use. Consider, for example,
a simple "task" for a thread pool:

    pool.execute(new Runnable() {
        @Override
        public void run() {
            System.out.println("Hello, world!");
        }
    });

(Sure, it's a dumb example.)

Even leaving out the optional-but-recommended `@Override` annotation, that's
still five lines of code that only exist to describe to the compiler how to
package up a block as an object. Yuck. For more sophisticated tasks, this sort
of verbosity has lead to multi-role "event handler" interfaces, to amortize
the syntactic cost across more blocks of code.

With Java 8's lambda support, the same (dumb) example collapses to

    pool.execute(() -> System.out.println("Hello, world"));

It's the same structure and is implemented very similarly by the compiler.
However, it's got much greater informational density for programmers reading
the code, and it's much more pleasant to write.

If there's any justice, this will completely change how people design Java
software.

## Event-Driven Systems

As an example, I knocked together a simple "event driven IO" system in an
evening, loosely inspired by node.js. Here's the echo server I wrote as an
example application, in its entirety:

    package com.example.onepointeight;
    
    import java.io.IOException;
    
    public class Echo {
        public static void main(String[] args) throws IOException {
            Reactor.run(reactor ->
                reactor.listen(3000, client ->
                    reactor.read(client, data -> {
                        data.flip();
                        reactor.write(client, data);
                    })
                )
            );
        }
    }

It's got a bad case of Javascript "arrow" disease, but it demonstrates the
expressive power of lambdas for callbacks. This is built on NIO, and runs in a
single thread; as with any decent multiplexed-IO application, it starts to
have capacity problems due to memory exhaustion well before it starts to
struggle with the number of clients. Unlike Java 7 and earlier, though, the
whole program is short enough to keep in your head without worrying about the
details of how each callback is converted into an object and without having to
define three or four extra one-method classes.

## Contextual operations

Sure, we all know you use `try/finally` (or, if you're up on your Java 7,
`try()`) to clean things up. However, context isn't always as tidy as that:
sometimes things need to happen while it's set up, and un-happen when it's
being torn down. The folks behind JdbcTemplate already understood that, so you
can already write SQL operations using a syntax similar to

    User user = connection.query(
        "SELECT login, group FROM users WHERE username = ?",
        username,
        rows -> rows.one(User::fromRow)
    );

Terser **and** clearer than the corresponding try-with-resources version:

    try (PreparedStatement ps = connection.prepare("SELECT login, group FROM users WHERE username = ?")) {
        ps.setString(1, username);
        try (ResultSet rows = rs.execute()) {
            if (!rows.next())
                throw new NoResultFoundException();
            return User.fromRow(rows);
        }
    }

## Domain-Specific Languages

I haven't worked this one out, yet, but I think it's possible to use lambdas
to implement conversational interfaces, similar in structure to "fluent"
interfaces like
[UriBuilder](http://docs.oracle.com/javaee/6/api/javax/ws/rs/core/UriBuilder.html).
If I can work out the mechanics, I'll put together an example for this, but
I'm half convinced something like

    URI googleIt = Uris.create(() -> {
        scheme("http");
        host("google.com");
        path("/");
        queryParam("q", "hello world");
    });

is possible.

