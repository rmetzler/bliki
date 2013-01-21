# Considering MySQL? Choose Something Else

Thesis: databases fill roles ranging between pure storage and extensive data
processing; MySQL is differently bad at both poles.

(Real apps fall between these poles, and suffer variably from either set of
MySQL flaws.)

In the first section, I'll talk about [why MySQL is bad at storing
data](#storage). In the second, I'll talk about [why MySQL is bad at
processing data](#processing). In the third, I'll talk about why these
problems are inherent in the way MySQL was built and are not likely to be
fixed in the foreseeable future.

## Storage

Storage systems have four properties:

1. Take and store data they receive from applications.
2. Keep that data safe against loss or accidental change.
3. Provide stored data to applications on demand.
4. Give administrators effective management tools.

In a truly "pure" storage application, data-comprehension features
(constraints and relationships, nontrivial functions and aggregates) would go
totally unused. There is a time and a place for this: the return of "NoSQL"
storage systems attests to that.

Pure storage systems tend to be closely coupled to their "main" application:
consider most web/server app databases. "Secondary" clients tend to be
read-only (reporting applications, monitoring) or to be utilities in service
of the main application (migration tools, documentation tools). If you believe
constraints, validity checks, and other comprehension features can be
implemented in "the application", you are probably thinking of databases close
to this pole.

### Storing Data

MySQL has many edge cases which reduce the predictability of its behaviour
when storing information. Most of these edge cases are documented, but violate
the principle of least surprise (not to mention the expectations of users
familiar with other SQL implementations).

* Implicit conversions (particularly to and from string types) can modify
  MySQL's behaviour.
    * Many implicit conversions are also silent (no warning, no diagnostic),
      by design, making it more likely developers are entirely unaware of
      them until one does something surprising.
* Conversions that violate basic constraints (range, length) of the output
  type often coerce data rather than failing.
    * Sometimes this raises a warning; does your app check for those?
    * This behaviour is unlike many typed systems (but closely like PHP and
      remotely like Perl).
* Conversion behaviour depends on a per-connection configuration value with a
  large constellation of possible states, making it harder to carry
  expectations from manual testing over to code.

### Preserving Data

... against unexpected changes: like most disk-backed storage systems, MySQL
is as reliable as the disks and filesystems its data lives on.

... against loss: hoo boy. MySQL's default approach to
[backups](http://dev.mysql.com/doc/refman/5.5/en/backup-methods.html) is to
either dump data to SQL periodically (slow and an inefficient use of space,
with little support for incremental backups) or to use binary logs (plus a
base filesystem backup) for ongoing backups. (Binary logs are also the basis
of MySQL's first-party replication system.) If neither of these are
sufficient, you're left with purchasing [a backup tool from
Oracle](http://dev.mysql.com/doc/refman/5.5/en/glossary.html#glos_mysql_enterprise_backup).

Like many of MySQL's features, the binary logging feature is
[too](http://dev.mysql.com/doc/refman/5.5/en/binary-log.html)
[configurable](http://dev.mysql.com/doc/refman/5.5/en/replication-options-binary-log.html),
while still, somehow, defaulting to modes that are hazardous or surprising:
the
[default](http://dev.mysql.com/doc/refman/5.5/en/replication-options-binary-log.html#sysvar_binlog_format)
[behaviour](http://dev.mysql.com/doc/refman/5.5/en/replication-formats.html)
is to log SQL statements, rather than logging their side effects. This has
lead to numerous bugs over the years; MySQL now makes an effort to make common
"non-deterministic" cases such as `NOW()` and `RANDOM()` act deterministically
but these have been addressed using ad-hoc solutions. Restoring
binary-log-based backups can easily lead to data that differs from the
original system, and by the time you've noticed the problem, it's too late to
do anything about it.

(Seriously. The binlog contains the current time on the master and the random
seed for every statement, just in case. If your non-deterministic query uses
any other function, you're still fucked by default.)