# Nobody Cares About Your Build

Every software system, from simple Python packages to huge enterprise-grade
systems spanning massive clusters, has a build—a set of steps that must be
followed to go from a source tree or a checked-out project to a ready-to-use
build product. A build system's job is to automate these steps.

Build systems are critical to software development.

They're also one of the most common avoidable engineering failures.

A reliable, comfortable build system has measurable benefits for software
development. Being able to build a testable, deployable system at any point
during development lets the team test more frequently. Frequent testing
isolates bugs and integration problems earlier, reducing their impact. Simple,
working builds allow new team members to ramp up more quickly on a project:
once they understand how one piece of the system is constructed, they can
apply that knowledge to the entire system and move on to doing useful work. If
releases, the points where code is made available outside the development
team, are done using the same build system that developers use in daily life,
there will be fewer surprises during releases as the “release” build process
will be well-understood from development.

## Builds Have Needs, Too

In 1947, Abraham Maslow described a [hierarchy of
needs](http://en.wikipedia.org/wiki/Maslow's_hierarchy_of_needs) for a
person's physical and mental well-being on the premise that all the items at
the lowest level of the hierarchy must be met before a person will be able to
focus usefully on higher-level needs. Maslow's hierarchy begins with a set of
needs that, without which, you do not have a person (for long)—physiological
needs like "breathing," "food," and "water." At the peak, there are extremely
high-level needs that are about being a happy and enlightened
person—"creativity," "morality," "curiosity," and so on.

![A three-tier pyramid. At the bottom: Automatable. Repeatable. Standardized.
Extensible. Understood. In the middle tier: Simple. Fast. Unit tests. Part of
the project. Environment independent. At the top: Metrics. Parallel builds.
Acceptance tests. Product caching. IDE integration.](buildifesto-pyramid)

Builds, and software engineering as a whole, can be described the same way: at
the top of the hierarchy is a working system that solves a problem, and at the
bottom are the things you need to have software at all. If you don't meet
needs at a given level, you will eventually be forced to stop what you're
doing at a higher level and face them.

Before a build is a build, there are five key needs to meet:

* **It must be repeatable**. Every time you start your build on a given source
  tree, it must build exactly the same products without any further
  intervention. Without this, you can't reliably decide whether a given build
  is "good," and can easily wind up with a build that needs to be run several
  times, or a build that relies on running several commands in the right
  order, to produce a build.
* **It must be automatable**. Build systems are used by developers sitting at
  their desks, but they’re also used by automatic build systems for nightly
  builds and continuous integration, and they can be made into parts of other
  builds. A build system that can only be run by having someone sit down at a
  keyboard and mouse and kicking it off can’t be integrated into anything
  else.
* **It must be standardized**. If you have multiple projects that build
  similar things—for example, several Java libraries—all of them must be built
  the same way. Without this, it's difficult for a developer to apply
  knowledge from one project to another, and it's difficult to debug problems
  with individual builds.
* **It must be extensible**. Not all builds are created equal. Where one build
  compiles a set of source files, another needs five libraries and a WSDL
  descriptor before it can compile anything. There must be affordances within
  the standard build that allow developers to describe the ways their build is
  different. Without this, you have to write what amounts to a second build
  tool to ensure that all the "extra" steps for certain projects happen.
* **Someone must understand it**. A build nobody understands is a time bomb:
  when it finally breaks (and it will), your project will be crippled until
  someone fixes it or, more likely, hacks around it.

If you have these five things, you have a working build. The next step is to
make it comfortable. Comfortable builds can be used daily for development
work, demonstrations, and tests as well as during releases; builds that are
used constantly don't get a chance to "rust" as developers ignore them until a
release or a demo and don’t hide surprises for launch day.

* **It must be simple**. When a complicated build breaks, you need someone who
  understands it to fix it for you. Simple builds mean more people can
  understand it and fewer things can break.
* **It must be fast**. A slow build will be hacked around or ignored entirely.
  Ideally, someone creating a local build for a small change should have a
  build ready in seconds.
* **It must be part of the product**. The team responsible for developing a
  project must be in control of and responsible for its build. Changes to it
  and bugs against it must be treated as changes to the product or bugs in the
  product.
* **It must run unit tests**. Unit tests, which are completely isolated tests
  written by and for developers, can catch a large number of bugs, but they're
  only useful if they get run. The build must run the unit test suite for the
  product it's building every build.
* **It must build the same thing in any environment**. A build is no good if
  developers can only get a working build from a specific machine, or where a
  build from one developer's machine is useless anywhere else. If the build is
  uniform on any environment, any developer can cook up a build for a test or
  demo at any time.

Finally, there are "chrome" features that take a build from effective to
excellent. These vary widely from project to project and from organization to
organization. Here are some common chrome needs:

* **It should integrate with your IDEs**. This goes both directions: it should
  be possible to run the build without leaving your IDE or editor suite, and
  it should be possible to translate the build system into IDE-specific
  configurations to reduce duplication between IDE settings and the build
  configuration.
* **It should generate metrics**. If you gather metrics for test coverage,
  common bugs, complexity analysis, or generate reports or documentation, the
  build system should be responsible for it. This keeps all the common
  administrative actions for the project in the same place as the rest of the
  configuration, and provides the same consistency that the system gives the
  rest of the build.
* **It should support multiple processors**. For medium-sized builds that
  aren’t yet large enough to merit breaking down into libraries, being able to
  perform independent build steps in parallel can be a major time-saver. This
  can extend to distributed build systems, where idle CPU time can be donated
  to other peoples’ builds.
* **It should run integration and acceptance tests**. Taking manual work from
  the quality control phase of a project and running it automatically during
  builds amplifies the benefits of early testing and, if your acceptance tests
  are good, when your project is done.
* **It should not need repeating**. Once you declare a particular set of build
  products "done", you should be able to use those products as-is any time you
  need them. Without this, you will eventually find yourself rebuilding the
  same code from the same release over and over again.

## What Doesn’t Work

Builds, like any other part of software development, have
antipatterns—recurring techniques for solving a problem that introduce more
problems.

* **One Source Tree, Many Products**. Many small software projects that
  survive to grow into large, monolithic projects are eventually broken up
  into components. It's easy to do this by taking the existing source tree and
  building parts of it, and it's also wrong. Builds that slice up a single
  source tree require too much discipline to maintain and too much mental
  effort to understand. Break your build into separate projects that are built
  separately, and have each build produce one product.
* **The Build And Deploy System**. Applications that have a server component
  often choose to automate deployment and setup using the same build system
  that builds the project. Too often, the extra build steps that set up a
  working system from the built project are tacked onto the end of an existing
  build. This breaks standardization, making that build harder to understand,
  and means that that one build is producing more than one thing—it's
  producing the actual project, and a working system around the project.
* **The Build Button**. IDEs are really good at editing code. Most of them
  will produce a build for you, too. Don't rely on IDE builds for your build
  system, and don't let the IDE reconfigure the build process. Most IDEs don't
  differentiate between settings that apply to the project and settings that
  apply to the local environment, leading to builds that rely on libraries or
  other projects being in specific places and on specific IDE settings that
  are often buried in complex settings dialogs.
* **Manual Steps**. Anything that gets done by hand will eventually be done
  wrong. Automate every step.

## What Does Work

Similarly, there are patterns—solutions that recur naturally and can be
applied to many problems.

* **Do One Thing Well**. The UNIX philosophy of small, cohesive tools works
  for build systems, too: if you need to build a package, and then install it
  on a server, write three builds: one that builds the package, one that takes
  a package and installs it, and a third that runs the first two builds in
  order. The individual builds will be small enough to easily understand and
  easy to standardize, and the package ends up installed on the server when
  the main build finishes.
* **Dependency Repositories**. After a build is done, make the built product
  available to other builds and to the user for reuse rather than rebuilding
  it every time you need it. Similarly, libraries and other inward
  dependencies for a build can be shared between builds, reducing duplication
  between projects.
* **Convention Over Extension**. While it's great that your build system is
  extensible, think hard about whether you really need to extend your build.
  Each extension makes that project’s build that much harder to understand and
  adds one more point of failure.

## Pick A Tool, Any Tool

Nothing here is new. The value of build systems has been
[discussed](http://www.joelonsoftware.com/articles/fog0000000043.html)
[in](http://www.gamesfromwithin.com/articles/0506/000092.html)
[great](http://c2.com/cgi/wiki?BuildSystem)
[detail](http://www.codinghorror.com/blog/archives/000988.html) elsewhere.
Much of the accumulated build wisdom of the software industry has already been
incorporated to one degree or another into build tools. What matters is that
you pick one, then use it with the discipline needed to get repeatable results
without thinking.
