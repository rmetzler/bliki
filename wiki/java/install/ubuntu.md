# Installing Java on Ubuntu

Accurate as of: Java 7, Ubuntu 12.04. The instructions below assume an amd64
(64-bit) installation. If you're still using a 32-bit OS, work out the
differences yourself.

## Via Package Management (Apt)

OpenJDK 7 is available via apt by default.

To install the JDK:

    sudo aptitude update
    sudo aptitude install openjdk-7-jdk

To install the JRE only (without the JDK):

    sudo aptitude update
    sudo aptitude install openjdk-7-jre

To install the JRE without GUI support (appropriate for headless servers):

    sudo aptitude update
    sudo aptitude install openjdk-7-jre-headless

(You can also use `apt-get` instead of `aptitude`.)

These packages interact with [the `alternatives`
system](http://manpages.ubuntu.com/manpages/hardy/man8/update-alternatives.8.html),
and have [a dedicated `alternatives` manager
script](http://manpages.ubuntu.com/manpages/hardy/man8/update-java-alternatives.8.html).
The `alternatives` system affects `/usr/bin/java`, `/usr/bin/javac`, and
browser plugins for applets and Java Web Start applications for browsers
installed via package management. It also affects the symlinks under
`/etc/alternatives` related to Java.

To list Java versions available, with at least one Java version installed via
Apt:

    update-java-alternatives --list

To switch to `java-1.7.0-openjdk-amd64` for all Java invocations:

    update-java-alternatives --set java-1.7.0-openjdk-amd64

The value should be taken from the first column of the `--list` output.

### Tool support

Most modern Java tools will pick up the installed JDK via `$PATH` and do not
need the `JAVA_HOME` environment variable set explicitly. For applications old
enough not to be able to detect the JDK, you can set `JAVA_HOME` to
`/usr/lib/jvm/java-1.7.0-openjdk-amd64`.

## By Hand

The [Java SE Development Kit
7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
tarballs can be installed by hand. Download the "Linux x64" `.tar.gz` version,
then unpack it in `/opt`:

    cd /opt
    tar xzf ~/jdk-7u45-linux-x64.tar.gz

This will create a directory named `/opt/jdk1.7.0_45` (actual version number
may vary) containing a ready-to-use Java dev kit.

You will need to add the JDK's `bin` directory to `PATH` if you want commands
like `javac` and `java` to work without fully-qualifying the directory:

    cat > /etc/profile.d/oracle_jdk <<'ORACLE_JDK'
    PATH="${PATH}:/opt/jdk1.7.0_45/bin"
    export PATH
    ORACLE_JDK

(This will not affect non-interactive use; setting PATH for non-interactive
programs like build servers is beyond the scope of this document. Learn to use
your OS.)

Installation this way does _not_ interact with the alternatives system (but
you can set that up by hand if you need to).

For tools that cannot autodetect the JDK via `PATH`, you may need to set
`JAVA_HOME` to `/opt/jdk1.7.0_45`.
