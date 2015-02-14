# JDBC Drivers and `Class.forName()`

The short version: stop using `Class.forName(driverClass)` to load JDBC
drivers. You don't need this, and haven't since Java 6. You arguably never
needed this.

This pattern appears all over the internet, and it's wrong.

## Backstory

JDBC has more or less always provided two ways to set up `Connection` objects:

1. Obtain them from a driver-provided `DataSource` class, which applications or
   containers are expected to create for themselves.

2. Obtain them by passing a URL to `DriverManager`.

Most people start with the latter, since it's very straightforward to use.
However, `DriverManager` needs to be able to locate `Driver` subclasses, and
the JVM doesn't permit class enumeration at runtime.

In the original JDBC release, `Driver` subclasses were expected to register
themselves on load, similar to

    public class ExampleDriver extends Driver {
        static {
            DriverManager.registerDriver(ExampleDriver.class);
        }
    }

Obviously, applications _can_ force drivers to load using
`Class.forName(driverName)`, but this hasn't ever been the only way to do it.
`DriverManager` also provides [a mechanism to load a set of named classes at
startup](https://docs.oracle.com/javase/8/docs/api/java/sql/DriverManager.html),
via the `jdbc.drivers` [system property](http://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html).

## JDBC 4 Fixed That

JDBC 4, which came out with Java 6 in the Year of our Lord _Two Thousand and
Six_, also loads drivers using the [service
provider](https://docs.oracle.com/javase/8/docs/technotes/guides/jar/jar.html#Service%20Provider)
system, which requires no intervention at all from deployers or application
developers.

_You don't need to write any code to load a JDBC 4 driver._

## What's The Harm?

It's harmless in the immediate sense: forcing a driver to load immediately
before JDBC would load it itself has no additional side effects. However, it's
a pretty clear indicator that you've copied someone else's code without
thoroughly understanding what it does, which is a bad habit.

## But What About My Database?

You don't need to worry about it. All of the following drivers support JDBC
4-style automatic discovery:

* PostgreSQL (since version 8.0-321, in 2007)

* Firebird (since [version 2.2, in 2009](http://tracker.firebirdsql.org/browse/JDBC-140))

* [MySQL](../mysql/choose-something-else) (since [version 5.0, in 2005](http://dev.mysql.com/doc/relnotes/connector-j/en/news-5-0-0.html))

* H2 (since day 1, as far as I can tell)

* Derby/JavaDB (since [version 10.2.1.6, in 2006](https://issues.apache.org/jira/browse/DERBY-930))

* SQL Server (version unknown, because MSDN is archaeologically hostile)
