# Glassfish and Upstart

**Warning**: the article you're about to read is largely empirical. Take
everything in it in a grain of salt, and _verify it yourself_ before putting
it into production. You have been warned.

The following observations apply to Glassfish 3.1.2.2. Other versions probably
act similarly, but check the docs.

## `asadmin create-service`

Glassfish is capable of emitting SysV init scripts for the DAS, or for any
instance. These init scripts wrap `asadmin start-domain` and `asadmin
start-local-instance`. However, the scripts it emits are (justifiably)
minimalist, and it makes some very strong assumptions about the layout of your
system's rc.d trees and about your system's choice of runlevels. The minimal
init scripts avoid any integration with platform "enhancements" (such as
Redhat's `/var/lock/subsys` mechanism and `condrestart` convention, or
Debian's `start-stop-daemon` helpers) in the name of portability, and the
assumptions it makes about runlevels and init layout are becoming
incrementally more fragile as more distributions switch to alternate init
systems with SysV compatiblity layers.

## Fork and `expect`

Upstart's process tracking mechanism relies on services following one of three
forking models, so that it can accurately track which children of PID 1 are
associated with which services:

* No `expect` stanza: The service's "main" process is expected not to fork at
  all, and to remain running. The process started by upstart is the "main"
  process.

* `expect fork`: The service is expected to call `fork()` or `clone()` once.
  The process started by upstart itself is not the "main" process, but its
  first child process is.

* `expect daemon`: The service is expected to call `fork()` or `clone()`
  twice. The first grandchild process of the one started by upstart itself is
  the "main" process. This corresponds to classical Unix daemons, which fork
  twice to properly dissociate themselves from the launching shell.

Surprisingly, `asadmin`-launched Glassfish matches _none_ of these models, and
using `asadmin start-domain` to launch Glassfish from Upstart is not, as far
as I can tell, possible. It's tricky to debug why, since JVM thread creation
floods `strace` with chaff, but I suspect that either `asadmin` or Glassfish
itself is forking too many times.

From [this mailing list
thread](https://java.net/projects/glassfish/lists/dev/archive/2012-02/message/9),
though, it appears to be safe to launch Glassfish directly, using `java -jar
GLASSFISH_ROOT/modules/glassfish.jar -domain DOMAIN`. This fits nicely into
Upstart's non-forking expect mode, but you lose the ability to pass VM
configuration settings to Glassfish during startup. Any memory settings or
Java environment properties you want to pass to Glassfish have to be passed to
the `java` command manually.

You also lose `asadmin`'s treatment of Glassfish's working directory. Since
Upstart can configure the working directory, this isn't a big deal.

## `SIGTERM` versus `asadmin stop-domain`

Upstart always stops services by sending them a signal. While you can dictate
which signal it uses, you cannot replace signals with another mechanims.
Glassfish shuts down abruptly when it recieves `SIGTERM` or `SIGINT`, leaving
some ugly noise in the logs and potentially aborting any transactions and
requests in flight. The Glassfish developers believe this is harmless and that
the server's operation is correct, and that's probably true, but I've not
tested its effect on outward-facing requests or on in-flight operations far
enough to be comfortable with it.

I chose to run a "clean"(er) shutdown using `asadmin stop-domain`. This fits
nicely in Upstart's `pre-stop` step, _provided you do not use Upstart's
`respawn` feature_. Upstart will correctly notice that Glassfish has already
stopped after `pre-stop` finishes, but when `respawn` is enabled Upstart will
treat this as an unexpected termination, switch goals from `stop` to
`respawn`, and restart Glassfish.

(The Upstart documentation claims that `respawn` does not apply if the tracked
process exits during `pre-stop`. This may be true in newer versions of
Upstart, but the version used in Ubuntu 12.04 does restart Glassfish if it
stops during `pre-stop`.)

Yes, this does make it impossible to stop Glassfish, ever, unless you set a
respawn limit.

Fortunately, you don't actually want to use `respawn` to manage availability.
The `respawn` mode cripples your ability to manage the service "out of band"
by forcing Upstart to restart it as a daemon every time it stops for any
reason. This means you cannot stop a server with `SIGTERM` or `SIGKILL`; it'll
immediately start again.

## `initctl reload`

It sends `SIGHUP`. This does not reload Glassfish's configuration. Deal with
it; use `initctl restart` or `asadmin restart-domain` instead. Most of
Glassfish's configuration can be changed on the fly with `asadmin set` or
other commands anyways, so this is not a big limitation.

## Instances

Upstart supports "instances" of a service. This slots nicely into Glassfish's
ability to host multiple domains and instances on the same physical hardware.
I ended up with a generic `glassfish-domain.conf` Upstart configuration:

    description "Glassfish DAS"
    console log

    instance $DOMAIN

    setuid glassfish
    setgid glassfish
    umask 0022
    chdir /opt/glassfish3

    exec /usr/bin/java -jar /opt/glassfish3/glassfish/modules/glassfish.jar -domain "${DOMAIN}"

    pre-stop exec /opt/glassfish3/bin/asadmin stop-domain "${DOMAIN}"

Combined with a per-domain wrapper:

    description "Glassfish 'example' domain"
    console log

    # Consider using runlevels here.
    start on started networking
    stop on deconfiguring-networking

    pre-start script
        start glassfish-domain DOMAIN=example
    end script

    post-stop script
        stop glassfish-domain DOMAIN=example
    end script

## Possible refinements

* Pull system properties and VM flags from the domain's own `domain.xml`
  correctly. It might be possible to abuse the (undocumented, unsupported, but
  helpful) `--_dry-run` argument from `asadmin start-domain` for this, or it
  might be necessary to parse `domain.xml` manually, or it may be possible to
  exploit parts of Glassfish itself for this.

* The `asadmin` cwd is actually the domain's `config` dir, not the Glassfish
  installation root.

* Something something something password files.

* Syslog and logrotate integration would be useful. The configurations above
  spew Glassfish's startup output and stdout to
  `/var/log/upstart/glassfish-domain-FOO.log`, which may not be rotated by
  default.