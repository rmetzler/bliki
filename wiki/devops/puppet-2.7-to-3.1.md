# Notes on upgrading Puppet from 2.7 to 3.1

## Bad

* As usual, you have to upgrade the puppet master first. 2.7 agents can speak
  to 3.1 masters just fine, but 3.1 agents cannot speak to 2.7 masters.

* I tried to upgrade the Puppet master using both `puppet agent` (failed when
  package upgrades shut down the puppet master) and `puppet apply` (failed for
  Ubuntu-specific reasons outlined below)

* [This bug](https://projects.puppetlabs.com/issues/19308).

* You more or less can't upgrade Puppet using Puppet.

## Good

* My 2.7 manifests worked perfectly under 3.1.

* Puppet's CA and SSL certs survived intact and required no maintenance after
  the upgrade.

* The Hiera integration into class parameters works as advertised and really
  does help a lot.

* Once I figured out how to execute it, the upgrade was pretty smooth.

* No Ruby upgrade!

* Testing the upgrade in a VM sandbox meant being able to fuck up safely.
  [Vagrant](http://www.vagrantup.com) is super awesome.

## Package Management Sucks

Asking Puppet to upgrade Puppet went wrong on Ubuntu because of the way Puppet
is packaged: there are three (ish) Puppet packages, and Puppet's resource
evaluation bits try to upgrade and install one package at a time. Upgrading
only “puppetmaster” upgraded “puppet-common” but not “puppet,” causing Apt to
remove “puppet”; upgrading only “puppet” similarly upgraded “puppet-copmmon”
but not “puppetmaster,” causing Apt to remove “puppetmaster.”

The Puppet aptitude provider (which I use instead of apt-get) for Package
resources also doesn't know how to tell aptitude what to do with config files
during upgrades. This prevented Puppet from being able to upgrade pacakges
even when running standalone (via `puppet apply`).

Finally, something about the switchover from Canonical's Puppet .debs to
Puppetlabs' .debs caused aptitude to consider all three packages “broken”
after a manual upgrade ('aptitude upgrade puppet puppetmaster'). Upgrading the
packages a second time corrected it; this is the path I eventually took with
my production puppetmaster and nodes.
