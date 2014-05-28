# Liquibase

Note to self: I think this (a) needs an outline and (b) wants to become a “how
to automate db upgrades for dummies” page. Also, this is really old (~2008)
and many things have changed: database migration tools are more
widely-available and mature now. On the other hand, I still see a lot of
questions on IRC that are based on not even knowing these tools exist.

-----

Successful software projects are characterized by extensive automation and
supporting tools. For source code, we have version control tools that support
tracking and reviewing changes, marking particular states for release, and
automating builds. For databases, the situation is rather less advanced in a
lot of places: outside of Rails, which has some rather nice
[migration](http://wiki.rubyonrails.org/rails/pages/understandingmigrations)
support, and [evolutions](http://code.google.com/p/django-evolution/) or
[South](http://south.aeracode.org) for Django, there are few tools that
actually track changes to the database or to the model in a reproducible way.

While I was exploring the problem by writing some scripts for my own projects,
I came to a few conclusions. You need to keep a receipt for the changes a
database has been exposed to in the database itself so that the database can
be reproduced later. You only need scripts to go forward from older versions
to newer versions. Finally, you need to view DDL statements as a degenerate
form of diff, between two database states, that's not combinable the way
textual diff is except by concatenation.

Someone on IRC mentioned [Liquibase](http://www.liquibase.org/) and
[migrate4j](http://migrate4j.sourceforge.net/) to me. Since I was already in
the middle of writing a second version of my own scripts to handle the issues
I found writing the first version, I stopped and compared notes.

Liquibase is essentially the tool I was trying to write, only with two years
of relatively talented developer time poured into it rather than six weeks.

Liquibase operates off of a version table it maintains in the database itself,
which tracks what changes have been applied to the database, and off of a
configuration file listing all of the database changes. Applying new changes
to a database is straightforward: by default, it goes through the file and
applies all the changes that are in the file that are not already in the
database, in order. This ensures that incremental changes during development
are reproduced in exactly the same way during deployment, something lots of
model-to-database migration tools have a problem with.

The developers designed the configuraton file around some of the ideas from
[Refactoring
Databases](http://www.amazon.com/Refactoring-Databases-Evolutionary-Addison-Wesley-Signature/dp/0321293533),
and provided an [extensive list of canned
changes](http://www.liquibase.org/manual/home#available_database_refactorings)
as primitives in the database change scripts. However, it's also possible to
insert raw SQL commands (either DDL, or DML queries like `SELECT`s and
`INSERT`s) at any point in the change sequence if some change to the database
can't be accomplished with its set of refactorings. For truly hairy databases,
you can use either a Java class implementing your change logic or a shell
script alongside the configuration file.

The tools for applying database changes to databases are similarly flexible:
out of the box, liquibase can be embedded in a fairly wide range of Java
applications using servlet context listeners, a Spring adapter, or a Grails
adapter; it can also be run from an ant or maven build, or as a standalone
tool.

My biggest complaint is that liquibase is heavily Java-centric; while the
developers are planning .Net support, it'd be nice to use it for Python apps
as well. Triggering liquibase upgrades from anything other than a Java program
involves either shelling out to the `java` command or creating a JVM and
writing native glue to control the upgrade process, which are both pretty
painful. I'm also less than impressed with the javadoc documentation; while
the manual is excellent, the javadocs are fairly incomplete, making it hard to
write customized integrations.

The liquibase developers deserve a lot of credit for solving a hard problem
very cleanly.

*[DDL]: Data Definition Language
*[DML]: Data Manipulation Language
