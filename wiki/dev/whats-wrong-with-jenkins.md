# Something's Rotten in the State of Jenkins

Automated, repeatable testing is a fairly widely-accepted cornerstone of
mature software development. Jenkins (and its predecessor, Hudson) has the
unique privilege of being both an early player in the niche and
free-as-in-beer. The blog space is littered with interesting articles about
continuous builds, automated testing, and continuous deployment, all of which
conclude on “how do we make Jenkins do it?”

This is unfortunate, because Jenkins has some serious problems, and I want it
to stop informing the discussion.

## There's A Plugin For That

Almost everything in the following can be addressed using one or more plugins
from Jenkins' extensive plugin repository. That's good - a build system you
can't extend is kind of screwed - but it also means that the Jenkins team
haven't felt a lot of pressure to address key problems in Jenkins proper.

(Plus, the plugin ecosystem is its own kind of screwed. More on that later.)

To be clear: being able to fix it with plugins does not make Jenkins itself
_good_. Plugins are a non-response to fundamental problems with Jenkins.

## No Granularity

Jenkins builds are atomic: they either pass en suite, or fail en suite. Jenkins has no built-in support for recording that basic compilation succeeded, unit tests failed, but linting also succeeded.

You can fix this by running more builds, but then you run into problems with
...

## No Gating

... the inability to wait for multiple upstream jobs before continuing a
downstream job in a job chain. If your notional build pipeline is

1. Compile, then
2. Lint and unit test, then
3. Publish binaries for testers/users

then you need to combine the lint and unit test steps into a single build, or
tolerate occasionally publishing between zero and two copies of the same
original source tree.

## No Pipeline

The above are actually symptomatic of a more fundamental design problem in
Jenkins: there's no build pipeline. Jenkins is a task runner: triggers cause
tasks to run, which can cause further triggers. (Without plugins, Jenkins
can't even ensure that chains of jobs all build the same revisioins from
source control.)

I haven't met many projects whose build process was so simple you could treat
it as a single, pass-fail task, whose results are only interesting if the
whole thing succeeds.

## Plugin the Gap

To build a functional, non-trivial build process on top of Jenkins, you will
inevitably need plugins: plugins for source control, plugins for
notification, plugins for managing build steps, plugins for managing various
language runtimes, you name it.

The plugin ecosystem is run on an entirely volunteer basis, and anyone can
get a new plugin into the official plugin registry. This is good, in as much
as the barrier to entry _should_ be low and people _should_ be encouraged to
scratch itches, but it also means that the plugin registry is a swamp of
sporadically-maintained one-offs with inconsistent interfaces.

(Worse, even some _core_ plugins have serious maintenance deficits: have a
look at how long
[JENKINS-20767](https://issues.jenkins-ci.org/browse/JENKINS-20767) was open.
How many Jenkins users use Git?)

## The Plugin API

The plugin API also, critically, locks Jenkins into some internal design
problems. The sheer number of plugins, and the sheer number of maintainers,
effectively prevents any major refactoring of Jenkins from making progress.
Breaking poorly-maintained plugins inevitably pisses off the users who were,
quite happily, using whatever they'd cooked up, but with the maintainership
of plugins so spread out and so sporadic, there's no easy way for the Jenkins
team to, for example, break up the [4,000-line `Jenkins` class](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/jenkins/model/Jenkins.java).

## What Is To Be Done

Jenkins is great and I'm glad it exists. Jenkins moved the state of the art
for build servers forward very effectively, and successfully out-competed
more carefully-designed offerings that were not, in fact, better:
[Continuum](http://continuum.apache.org) is more or less abandoned, and when
was the last time you saw a
[CruiseControl](http://cruisecontrol.sourceforge.net) (caution: SourceForge)
install?

It's interesting to compare the state of usability in, eg., Jenkins, to the
state of usability in some paid-product build systems
([Bamboo](https://www.atlassian.com/software/bamboo) and
[TeamCity](https://www.jetbrains.com/teamcity/) for example) on the above
points, as well as looking at the growing number of hosted build systems
([TravisCI](https://travis-ci.org), [MagnumCI](https://magnum-ci.com)) for
ideas. A number of folks have also written insightful musings on what they
want to see in the next CI tool: Susan Potter's
[Carson](https://github.com/mbbx6spp/carson) includes an interesting
motivating metaphor (if you're going to use butlers, why not use the whole
butler mileu?) and some good observations on how Jenkins lets us all down,
for example.

I think it's time to put Jenkins to bed and write its successor.
