# Self-daemonizing code is awful

The classical UNIX approach to services is to implement them as "daemons",
programs that run without a terminal attached and provide some service. The
key feature of a classical daemon is that, when started, it carefully
detaches itself from its initial environment and terminal, then continues
running in the background.

This is awful and I'm glad modern init replacements discourage it.

## Process Tracking

Daemons don't exist in a vacuum. Administrators and owners need to be able to
start and stop daemons reliably, and check their status. The classic
self-daemonization approach makes this impossible.

Traditionally, daemons run as children of `init` (pid 1), even if they start
out as children of some terminal or startup process. Posix only provides
deterministic APIs for processes to manage their children and their immediate
parents; the classic daemonisation protocol hands the newly-started daemon
process off from its original parent process, which knows how to start and
stop it, to an unsuspecting `init`, which has no idea how this specific
daemon is special.

The standard workaround has daemons write their own PIDs to a file, but a
file is "dead" data: it's not automatically updated if the daemon dies, and
can linger long enough to contain the PID of some later, unrelated program.
PID file validity checks generally suffer from subtle (or, sometimes, quite
gross) race conditions.

## Complexity

The actual _code_ to correctly daemonize a process is surprisingly complex,
given the individual interfaces' relative simplicity:

* The daemon must start its own process group

* The daemon must detach from its controlling terminal

* The daemon should close (and may reopen) file handles inherited from its
  parent process (generally, a shell)

* The daemon should ensure its working directory is predictable and
  controllable

* The daemon should ensure its umask is predictable and controllable

* If the daemon uses privileged resources (such as low-numbered ports), it
  should carefully manage its effective, real, and session UID and GIDs

* Daemons must ensure that all of the above steps happen in signal-safe ways,
  so that a daemon can be shut down sanely even if it's still starting up

See [this list](http://www.freedesktop.org/software/systemd/man/daemon.html)
for a longer version. It's worse than you think.

All of this gets even more complicated if the daemon has its own child
processes, a pattern common to network services. Naturally, a lot of daemons
in the real world get some of these steps wrong.

## The Future

[Supervisord](http://supervisord.org),
[Foreman](http://ddollar.github.io/foreman/),
[Upstart](http://upstart.ubuntu.com),
[Launchd](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/launchctl.1.html),
[systemd](http://www.freedesktop.org/wiki/Software/systemd/), and [daemontools](http://cr.yp.to/daemontools.html) all
encourage services _not_ to self-daemonize by providing a sane system for
starting the daemon with the right parent process and the right environment
in the first place.

This is a great application of
[DRY](http://c2.com/cgi/wiki?DontRepeatYourself), as the daemon management
code only needs to be written once (in the daemon-managing daemon) rather
than many times over (in each individual daemon). It also makes daemon
execution more predictable, since daemons "in production" behave more like
they do when run attached to a developer's console during debugging or
development.
