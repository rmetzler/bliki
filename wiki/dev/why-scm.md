# Why we use SCM systems

I'm watching a newly-minted co-op student dealing with her first encounter
with Git, unhelpfully shepherded by a developer to whom everything below is
already second nature, so deeply that the reasoning is hard to articulate. It
is not going well.

I have the same problem, and it could be me trying to give someone an intro to
Git off the top of my head, but it's not, today. For next time, here are my
thoughts. They have shockingly little to do with Git.

## Assumptions

* You're working on a software project.
* You know how to read and write code.
* You're human.
* You have end users or customers - people other than yourself who care about
  your code.
* Your project is going to take more than a few minutes to reach end of life.

## The safety net

Having a record of past states and known-good states means that, when (WHEN)
you write some code that doesn't work, and when (WHEN) you're stumped as to
why, you can throw your broken code away and get to a working state again. It
also helps with less-drastic solutions by letting you run comparisons between
your broken code and working code, which helps narrow down whatever problem
you've created for yourself.

(Aside: if you're in a shop that "doesn't use source control", and for
whatever insane reason you haven't already run screaming, this safety net is a
good reason to use source control independently of the organization as a
whole. Go on, it's easy; modern DSCM tools like Mercurial or Git make
importing "external" trees pretty straightforward. Your future self thanks
you.)

## Historical record

Having a record of past, released states means you can go back later and
recover how your project has changed over time. Even if your commit practices
are terrible, when (WHEN) your users complain that something stopped working a
few months ago and they never bothered to mention it until now, you have some
chance of finding out what caused the problem. Better practices around [commit
messages](commit-messages) and other workflow-related artifacts improve your
chances of finding out _why_, too.

## Consensus

Every SCM system and every release process is designed to help the humans in
the loop agree on what, exactly, the software being released looks like and
whether or not various releasability criteria have been met. It doesn't matter
if you use rolling releases or carefully curate and tag every release after
months of discussion, you still need to be able to point to a specific version
of your project's source code and say "this will be our next release".

SCM systems can help direct and contextualize that discussion by recording the
way your project has changed during those discussion, whether that's part of
development or a separate post-"freeze" release process.

## Proposals and speculative development

Modern SCM systems (other than a handful of dismal early attempts) also help
you _propose_ and _discuss_ changes. Distributed source control systems make
this particularly easy, but even centralized systems can support workflows
that record speculative development in version control. The ability to discuss
specific changes and diffs, either within a speculative line of development or
between a proposed feature and the mainline code base, is incredibly powerful.

## The bottom line

It's about the people, not the tools, stupid. Explaining how Git works to
someone who doesn't have a good grasp on the relationship between source
control tools and long-term, collaborative software development won't help.
