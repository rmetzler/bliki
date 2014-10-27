# Falsehoods Programmers Beleive About Shutdown Hooks

Shutdown hooks are language features allowing programs to register callbacks to run during the underlying runtime's orderly teardown. For example:

* C's [`atexit`](http://man7.org/linux/man-pages/man3/atexit.3.html),

* Python's [`atexit`](https://docs.python.org/library/atexit.html), which is subtly different,

* Ruby's [`Kernel.at_exit`](http://www.ruby-doc.org/core-2.1.3/Kernel.html#method-i-at_exit), which is different again,

* Java's [Runtime.addShutdownHook](http://docs.oracle.com/javase/8/docs/api/java/lang/Runtime.html#addShutdownHook-java.lang.Thread-), which is yet again different

(There's an example in your favourite language.)

The following beliefs are widespread and incorrect:

1. **Your shutdown hook will run.** Non-exhaustively: the power can go away. The OS may terminate the program immediately because of resource shortages. An administrator or process management tool may send `SIGKILL` to the process. All of these things, and others, will not run your shutdown hook.

2. **Your shutdown hook will run last.** Look at the shapes of the various shutdown hook APIs above: they all allow multiple hooks to be registered in arbitrary orders, and at least one _outright requires_ that hooks run concurrently.

3. **Your shutdown hook will not run last.** Sometimes, you win, and objects your hook requires get cleaned up before your hook runs.

4. **Your shutdown hook will run to completion.** Some languages run shutdown hooks even when the original termination request came from, for example, the user logging out. Most environments give programs a finite amount of time to wrap up before forcibly terminating them; your shutdown hook may well be mid-run when this occurs.

5. **Your shutdown hook will be the only thing running.** In languages that support “daemon” threads, shutdown hooks may start before daemon threads terminate. In languages with concurrent shutdown hooks, other hooks will be in flight at the same time. On POSIX platforms, signals can still arrive during your shutdown hook. (Did you start any child processes? `SIGCHLD` can still arrive.)

Programs that rely on shutdown hooks for correctness should be treated as de-facto incorrect, much like object finalization in garbage-collected languages.
