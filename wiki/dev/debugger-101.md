# Intro to Debuggers

(Written largely because newbies in [##java](http://evanchooly.com) never seem
to have this knowledge.)

A "debugger" is a mechanism for monitoring and controlling the execution of
your program, usually interactively. Using a debugger, you can stop your
program at known locations and examine the _actual_ values of its variables
(to compare against what you expected), monitor variables for changes (to see
where they got the values they have, and why), and step through code a line at
a time (to watch control flow and verify that it matches your expectations).

Pretty much every worthwhile language has debugging support of some kind,
whether it's via IDE integration or via a command-line debugger.

(Of course, none of this helps if you don't have a mental model of the
"expected" behaviour of the program. Debuggers can help you read, but can't
replace having an understanding of the code.)

## Debugging Your First Program

Generally, you start running a debugger because you have a known problem -- an
exception, or code behaving strangely -- somewhere in your program that you
want to investigate more closely. Start by setting a _breakpoint_ in your
program at a statement slightly before the problem area.

Breakpoints are instructions to the debugger, telling it to stop execution
when the program reaches the statement the breakpoint is set on.

Run the program in the debugger. When it reaches your breakpoint, execution
will stop (and your program will freeze, rather than exiting). You can now
_inspect_ values and run expressions in the context of your program in its
current state. Depending on the debugger and the platform, you may be able to
modify those values, too, to quickly experiment with the problem and attempt
to solve it.

Once you've looked at the relevant variables, you can resume executing your
program - generally in one of five ways:

* _Continue_ execution normally. The debugger steps aside until the program
  reaches the next breakpoint, or exits, and your program executes normally.

* Execute the _next_ statement. Execution proceeds for one statement in the
  current function, then stops again. If the statement is, for example, a
  function or method call, the call will be completely evaluated (unless it
  contains breakpoints of its own). (In some debuggers, this is labelled "step
  over", since it will step "over" a function call.)

* _Step_ forward one operation. Execution proceeds for one statement, then
  stops again. This mode can single-step into function calls, rather than
  letting them complete uninterrupted.

* _Continue to end of function_. The debugger steps aside until the program
  reaches the end of the current function, then halts the program again.

* _Continue to a specific statement_. Some debuggers support this mode as a
  way of stepping over or through "uninteresting" sections of code quickly and
  easily. (You can implement this yourself with "Continue" and normal
  breakpoints, too.)

Whenever the debugger halts your program, you can do any of several things:

* Inspect the value of a variable or field, printing a useful representation
  to the debugger. This is a more flexible version of the basic idea of
  printing debug output as you go: because the program is stopped, you can
  pick and choose which bits of information to look at on the fly, rather than
  having to rerun your code with extra debug output.

* Inspect the result of an expression. The debugger will evaluate an
  expression "as if" it occurred at the point in the program where the
  debugger is halted, including any local variables. In languages with static
  visibility controls like Java, visibility rules are often relaxed in the
  name of ease of use, allowing you to look at the private fields of objects.
  The result of the expression will be made available for inspection, just
  like a variable.

* Modify a variable or field. You can use this to quickly test hypotheses: for
  example, if you know what value a variable "should" have, you can set that
  value directly and observe the behaviour of the program to check that it
  does what you expected before fixing the code that sets the variable in a
  non-debug run.

* In some debuggers, you can run arbitrary code in the context of the halted
  program.

* Abort the program.
