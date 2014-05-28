# Factor 7: Port Binding

[This](http://www.12factor.net/port-binding) is the exact point where the
Heroku-specific features of the approach overwhelm the general features.

Factor 7 is over-specific:

* It presupposes the existence of a front-end routing layer, without providing
  any insight into how to deploy, configure, provision, or manage one.

* It demands HTTP (by name) rather than a more flexible “any well-standardized
  protocol,” without explaining why. (Web apps can have non-HTTP internal
  components.)

* It dismisses the value of “pre-existing” container ecosystems that don't
  work the way Heroku does. Have a giant, well-managed
  [Glassfish](http://glassfish.org) cluster that you deploy components to? TOO
  BAD, not Heroku-like enough for these guys even though many aspects run
  along similar philosophical lines.

* It dismisses the value of unix-as-a-container. Unix domain sockets with
  controlled permissions? Psh, let's go through the network stack instead.
  SysV IPC? (Yeah, I know.) Network. Pipes? Network. There's an implicit
  exception for “intra-process” communication, but it's never really
  identified or reasoned about.

* Have you _seen_ the kinds of process control interfaces developers invent,
  when left to their own devices? Signals and PID files are well-established
  conventions, and smart, competent people still fuck those up all the time.
  Command-line arguments are another frequent case of NIH stupidity. Do you
  really want every app to have its own startup API?
