# Notes on Bootstrapping This Host

Presented without comment:

* Package updates:

        apt-get update
        apt-get upgrade

* Install Git:

        apt-get install git

* Set hostname:

        echo 'grimoire' > /etc/hostname
        sed -i -e $'s,ubuntu,grimoire.ca\tgrimoire,' /etc/hosts
        poweroff

    To verify:

        hostname -f # => grimoire.ca
        hostname    # => grimoire

* Add `owen` user:

        adduser owen
        adduser owen sudo

    To verify:

        id owen # => uid=1000(owen) gid=1000(owen) groups=1000(owen),27(sudo)

* Install Puppetlabs Repos:

        wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
        dpkg -i puppetlabs-release-pc1-trusty.deb
        apt-get update

* Install Puppet server:

        apt-get install puppetserver
        sed -i \
            -e '/^JAVA_ARGS=/ s,2g,512m,g' \
            -e '/^JAVA_ARGS=/ s, -XX:MaxPermSize=256m,,' \
            /etc/default/puppetserver
        service puppetserver start

* Test Puppet agent:

        /opt/puppetlabs/bin/puppet agent --test --server grimoire.ca

    This should output the following:

        Info: Retrieving pluginfacts
        Info: Retrieving plugin
        Info: Caching catalog for grimoire.ca
        Info: Applying configuration version '1446415926'
        Info: Creating state file /opt/puppetlabs/puppet/cache/state/state.yaml
        Notice: Applied catalog in 0.01 seconds

* Install environment:

        git init --bare /root/puppet.git
        # From workstation, `git push root@grimoire.ca:puppet.git master` to populate the repo
        rm -rf /etc/puppetlabs/code/environments/production
        git clone /root/puppet.git /etc/puppetlabs/code/environments/production

* Bootstrap puppet:

        /opt/puppetlabs/bin/puppet agent --test --server grimoire.ca
