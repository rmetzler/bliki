# MySQL's Two-Phase Commit Implementation Is Broken

From [the fine
manual](http://dev.mysql.com/doc/refman/5.5/en/xa-restrictions.html):

> If an XA transaction has reached the PREPARED state and the MySQL server is
> killed (for example, with kill -9 on Unix) or shuts down abnormally, the
> transaction can be continued after the server restarts. However, if the
> client reconnects and commits the transaction, the transaction will be
> absent from the binary log even though it has been committed. This means the
> data and the binary log have gone out of synchrony. An implication is that
> **XA cannot be used safely together with replication**.

(Emphasis mine.)

If you're solving the kinds of problems where two-phase commit and XA
transaction management look attractive, then you very likely have the kinds of
uptime requirements that make replication mandatory. "It works, but not with
replication" is effectively "it doesn't work".

> It is possible that the server will roll back a pending XA transaction, even
> one that has reached the PREPARED state. This happens if a client connection
> terminates and the server continues to run, or if clients are connected and
> the server shuts down gracefully.

XA transaction managers assume that if every resource successfully reaches the
PREPARED state, then every resource will be able to commit the transaction
"eventually". Resources that unilaterally roll back PREPARED transactions
violate this assumption pretty badly.
