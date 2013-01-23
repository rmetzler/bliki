# Do Not Pass This Way Again

Considering MySQL? Use something else. Already on MySQL? Migrate. For every
successful project built on MySQL, you could uncover a history of time wasted
mitigating MySQL's inadequacies, masked by a hard-won, but meaningless, sense
of accomplishment over the effort spent making MySQL behave.

Thesis: databases fill roles ranging from pure storage to complex and
interesting data processing; MySQL is differently bad at both tasks. Real apps
all fall somewhere between these poles, and suffer variably from both sets of
MySQL flaws.

* MySQL is bad at [storage](#storage).
* MySQL is bad at [data processing](#data-processing).

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
* Conversion behaviour depends on a per-connection configuration value
  (`sql_mode`) that has [a large constellation of possible
  states](http://dev.mysql.com/doc/refman/5.5/en/server-sql-mode.html), making
  it harder to carry expectations from manual testing over to code or from
  tool to tool.
* MySQL uses non-standard and rather unique interpretations of several common
  character encodings, including UTF-8 and Latin-1. Implementation details of
  these encodings within MySQL, such as the `utf8` encoding's MySQL-specific
  3-byte limit, tend to leak out into client applications. Data that does not
  fit MySQL's understanding of the storage encoding will be transformed until
  it does, by truncation or replacement, by default.

### Preserving Data

... against unexpected changes: like most disk-backed storage systems, MySQL
is as reliable as the disks and filesystems its data lives on. MySQL makes
very little effort to do its own storage validation and error correction, but
this is a limitation shared with many, _many_ other systems.

The implicit conversion rules that bite when storing data also bite when
asking MySQL to modify data - my favourite example being a fat-fingered
`UPDATE` query where a mistyped `=` (as `-`, off by a single key) caused 90%
of the rows in the table to be affected, instead of one row, because of
implicit string-to-integer conversions.

... against loss: hoo boy. MySQL, out of the box, gives you three approaches
to [backups](http://dev.mysql.com/doc/refman/5.5/en/backup-methods.html):

* Take "blind" filesystem backups with `tar` or `rsync`. Unless you
  meticulously lock tables or make the database read-only for the duration,
  this produces a backup that requires crash recovery before it will be
  usable, and can produce an inconsistent database.
    * This can bite quite hard if you use InnoDB, as InnoDB crash recovery
      takes time proportional to both the number of InnoDB tables and the
      total size of InnoDB tables, with a large constant.
* Dump to SQL with `mysqldump`: slow, relatively large backups, and
  non-incremental.
* Archive binary logs: fragile, complex, over-configurable, and configured
  badly by default. (Binary logging is also the basis of MySQL's replication
  system.)

If neither of these are sufficient, you're left with purchasing [a backup tool
from
Oracle](http://dev.mysql.com/doc/refman/5.5/en/glossary.html#glos_mysql_enterprise_backup)
or from one of the third-party MySQL vendors.

Like many of MySQL's features, the binary logging feature is
[too](http://dev.mysql.com/doc/refman/5.5/en/binary-log.html)
[configurable](http://dev.mysql.com/doc/refman/5.5/en/replication-options-binary-log.html),
while still, somehow, defaulting to modes that are hazardous or surprising:
the
[default](http://dev.mysql.com/doc/refman/5.5/en/replication-options-binary-log.html#sysvar_binlog_format)
[behaviour](http://dev.mysql.com/doc/refman/5.5/en/replication-formats.html)
is to log SQL statements, rather than logging their side effects. This has
lead to numerous bugs over the years; MySQL (now) makes an effort to make
common "non-deterministic" cases such as `NOW()` and `RANDOM()` act
deterministically but these have been addressed using ad-hoc solutions.
Restoring binary-log-based backups can easily lead to data that differs from
the original system, and by the time you've noticed the problem, it's too late
to do anything about it.

(Seriously. The binary log entries for each statement contain the "current"
time on the master and the random seed at the start of the statement, just in
case. If your non-deterministic query uses any other function, you're still
[fucked by
default](http://dev.mysql.com/doc/refman/5.5/en/replication-sbr-rbr.html#replication-sbr-rbr-sbr-disadvantages).)

### Retrieving Data

This mostly works as expected. Most of the ways MySQL will screw you happen
when you store data, not when you retrieve it. However, there are a few things
that implicitly transform stored data before returning it:

* `TIMESTAMP` columns (and _only_ `TIMESTAMP` columns) can return
  apparently-differing values for the same stored value depending on
  per-connection configuration even during read-only operation. This is done
  silently and the default behaviour can change as a side effect of non-MySQL
  configuration changes in the underlying OS.
* String-typed columns are transformed for encoding on output if the
  connection is not using the same encoding as the underlying storage, using
  the same rules as the transformation on input.
* Values that stricter `sql_mode` settings would reject during storage can
  still be returned during retrieval; it is impossible to predict in advance
  whether such data exists, since clients are free to set `sql_mode` to any
  value at any time.

### Efficiency

For purely store-and-retrieve applications, MySQL's query planner (which
transforms the miniature program contained in each SQL statement into a tree
of disk access and data manipulation steps) is sufficient, but only barely.
Queries that retrieve data from one table, or from one table and a small
number of one-to-maybe-one related tables, produce relatively efficient plans.

MySQL, however, offers a number of tuning options that can have dramatic and
counterintuitive effects, and the documentation provides very little advice
for choosing settings. Tuning relies on the administrator's personal
experience, blog articles of varying quality, and consultants.

* The MySQL query cache defaults to a non-zero size in some commonly-installed
  configurations. However, the larger the cache, the slower writes proceed:
  invalidating cache entries that include the tables modified by a query means
  considering every entry in the cache. This cache also uses MySQL's LRU
  implementation, which has its own performance problems during eviction that
  get worse with larger cache sizes.
* Memory-management settings, including `key_buffer_size` and `innodb_buffer_pool_size`,
  have non-linear relationships with performance. The [standard](http://www.mysqlperformanceblog.com/2006/09/29/what-to-tune-in-mysql-server-after-installation/)
  [advice](http://www.mysqlperformanceblog.com/2007/11/01/innodb-performance-optimization-basics/) advises
  making whichever value you care about more to a large value, but this can be
  counterproductive if the related data is larger than the pool can hold:
  MySQL is once again bad at discarding old buffer pages when the buffer is
  exhausted, leading to dramatic slowdowns when query load reaches a certain
  point.
    * This also affects filesystem tuning settings such as `table_open_cache`.
* InnoDB, out of the box, comes configured to use one large (and automatically
  growing) tablespace file for all tables, complicating backups and storage
  management. This is fine for trivial databases, but MySQL provides no tools
  (aside from `DROP TABLE` and reloading the data from an SQL dump) for
  transplanting a table to another tablespace, and provides no tools (aside
  from a filesystem-level `rm`, and reloading _all_ InnoDB data from an SQL
  dump) for reclaiming empty space in a tablespace file.
* MySQL itself provides very few tools to manage storage; tasks like storing
  large or infrequently-accessed tables and databases on dedicated filesystems
  must be done on the filesystem, with MySQL shut down.

## Data Processing

Data processing encompasses tasks that require making decisions about data and
tasks that derive new data from existing data. This is a huge range of topics:

* Deciding (and enforcing) application-specific validity rules.
* Summarizing and deriving data.
* Providing and maintaining alternate representations and structures.
* Hosting complex domain logic near the data it operates on.

The further towards data processing tasks applications move, the more their
SQL resembles tiny programs sent to the data. MySQL is totally unprepared for
programs, and expects SQL to retrieve or modify simple rows.

### Validity

Good constraints are like `assert`s: in an ideal world, you can't tell if they
work, because your code never violates them. Here in the real world,
constraint violations happen for all sorts of reasons, ranging from buggy code
to buggy human cognition. A good database gives you more places to describe
your expectations and more tools for detecting and preventing surprises.
MySQL, on the other hand, can't validate your data for you, beyond simple (and
fixed) type constraints:

* As with the data you store in it, MySQL feels free to change your table
  definitions [implicitly and
  silently](http://dev.mysql.com/doc/refman/5.5/en/silent-column-changes.html).
  Many of these silent schema changes have important performance and
  feature-availability implications.
* Foreign keys, one of the most widely-used database validity checks, are an
  engine-specific feature, restricting their availabilty in combination with
  other engine-specific features. (For example, a table cannot have both
  foreign key constraints and full-text indexes, as of MySQL 5.5.)
    * Configurations that violate assumptions about foreign keys, such as a
      foreign key pointing into a MyISAM or NDB table, do not cause warnings
      or any other diagnostics. The foreign key is simply discarded. SURPRISE.
      (MySQL is riddled with these sorts of surprises, and apologists lean
      very heavily on the "that's documented" excuse for its bad behaviour.)
* The MySQL parser recognizes `CHECK` clauses, which allow schema developers
  to make complex declarative assertions about tuples in the database, but
  [discards them without
  warning](http://dev.mysql.com/doc/refman/5.5/en/create-table.html). If you
  want `CHECK`-like constraints, you must implement them as triggers - but see
  below...
* MySQL's comprehension of the `DEFAULT` clause is, uh, limited: only
  constants are permitted, except for the [special
  case](https://dev.mysql.com/doc/refman/5.5/en/timestamp-initialization.html)
  of at most one `TIMESTAMP` column per table. Who designed this mess?
    * Furthermore, there's no way to say "no default" and raise an error when
      an INSERT forgets to provide a value. The default `DEFAULT` is either
      `NULL` or a zero-like constant (`0`, `''`, and so on). Even for types
      with no meaningful zero-like values (`DATETIME`).
* MySQL has no mechanism for introducing new types, which might otherwise
  provide a route to enforcing validity. Counting the number of special cases
  in MySQL's [existing type
  system](http://dev.mysql.com/doc/refman/5.5/en/data-types.html) illustrates
  why that's probably unfixable.

I hope every client with write access to your data is absolutely perfect,
because MySQL _cannot help you_ if you make a mistake.

### Summarizing and Deriving Data

SQL databases generally provide features for doing "interesting" things with
sets of tuples, and MySQL is no exception. However, MySQL's limitations mean
that actually processing data in the database is fraught with wasted money,
brains, and time:

* Aggregate (`GROUP BY`) queries run up against limits in MySQL's query
  planner: a query with both `WHERE` and `GROUP BY` clauses can only satisfy
  one constraint or the other with indexes, unless there's an index that
  covers all the relevant fields in both clauses, in the right order. (What
  this order is depends on the complexity of the query and on the distribution
  of the underlying data, but that's hardly MySQL-specific.)
    * If you have all three of `WHERE`, `GROUP BY`, and `ORDER BY` in the same
      query, you're more or less fucked. Good luck designing a single index
      that satisfies all three.
* Even though MySQL allows database administrators to [define normal functions
  in a procedural SQL
  dialect](http://dev.mysql.com/doc/refman/5.5/en/create-procedure.html),
  [custom aggregate
  functions](http://dev.mysql.com/doc/refman/5.5/en/create-function-udf.html)
  can only be defined by native plugins. Good thing, too, because procedural
  SQL in MySQL is its own kind of awful - more on that below.
* Subqueries are often convenient and occasionally necessary for expressing
  multi-step transformations on some underlying data. MySQL's query planner
  has only one strategy for optimizing them: evaluate the innermost query as
  written, into an in-memory table, then use a nested loop to satisfy joins or
  `IN` clauses. For large subquery results or interestingly nested subqueries,
  this is absurdly slow.
    * MySQL's query planner can't fold constraints from outer queries into
      subqueries.
    * The generated in-memory table never has any indexes, ever, even when
      appropriate indexes are "obvious" from the surrounding query; you cannot
      even specify them.
    * These limitations also affect views, which are evaluated as if they were
      subqueries. In combination with the lack of constraint folding in the
      planner, this makes filtering or aggregating over large views completely
      impractical.
    * MySQL lacks [common table
      expressions](http://www.postgresql.org/docs/9.2/static/queries-with.html).
      Even if subquery efficiency problems get fixed, the inability to give
      meaningful names to subqueries makes them hard to read and comprehend.
    * I hope you like `CREATE TEMPORARY TABLE AS SELECT`, because that's your
      only real alternative.
* [Window
  functions](http://en.wikipedia.org/wiki/Select_(SQL)#Window_function) do not
  exist at all in MySQL. This complicates many kinds of analysis, including
  time series analyses and ranking analyses.
    * Specific cases (for example, assigning rank numbers to rows) can be
      implemented using [server-side variables and side effects during
      `SELECT`](http://stackoverflow.com/questions/6473800/assigning-row-rank-numbers).
      What? Good luck understanding that code in six months.
* Even interesting joins run into trouble. MySQL's query planner has trouble
  with a number of cases that can easily arise in well-normalized data:
    * Joining and ordering by rows from multiple tables often forces MySQL to
      dump the whole join to a temporary table, then sort it -- awful,
      especially if you then use `LIMIT BY` to paginate the results.
    * `JOIN` clauses with non-trivial conditions, such as joins by range or
      joins by similarity, generally cause the planner to revert to table
      scans even if the same condition would be indexable outside of a join.
    * Joins with `WHERE` clauses that span both tables, where the rows
      selected by the `WHERE` clause are outliers relative to the table
      statistics, often cause MySQL to access tables in suboptimal order.

And now you know why MySQL advocates are such big fans of doing data
_processing_ in "the client" or "the app".