# Installing Java on CentOS

Verified as of CentOS 5.8, Java 6. CentOS 6 users: fucking switch to Debian
already. Is something wrong with you? Do you like being abused by your
vendors?

## From Package Management (Yum)

OpenJDK is available via [EPEL](http://fedoraproject.org/wiki/EPEL/FAQ), from
the Fedora project. Install EPEL before proceeding.

You didn't install EPEL. Go install EPEL. [The directions are in the EPEL
FAQ](http://fedoraproject.org/wiki/EPEL/FAQ#Using_EPEL).

Now install the JDK:

    sudo yum install java-1.6.0-openjdk-devel

Or just the runtime:

    sudo yum install java-1.6.0-openjdk

The RPMs place the appropriate binaries in `/usr/bin`.

Applications that can't autodetect the JDK may need `JAVA_HOME` set to
`/usr/lib/jvm/java-openjdk`.

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
