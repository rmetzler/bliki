# Bugs, Tasks, and Tickets from First Principles

Why do we track tasks?

* To communicate about what should, will, has, and will not be done.
    * Consequently, to either build consensus on what to do next or to dictate
      it.
* To measure and communicate progress.
* To preserve information for future use.
    * Otherwise we'd just remember it in our heads.
    * Wishlist tasks are not a bad thing!

Bugs/defects are a kind of task but not the only kind. Most teams have a "bug
tracker" that contains a lot more than bugs. Let's not let bugs dictate the
system.

* Therefore, "steps to reproduce" should not be a required datum.

Bugs are an _important_ kind of task.

Tasks can be related to software development artifacts: commits, versions,
builds, releases.

* A task may only be complete as of certain commits/releases/builds.
* A task may only be valid after (or before) certain commits/releases/builds.

Communication loosely implies publishing. Tracking doesn't, but may rely on
the publishing of other facts.

## Core Data

Tasks are only useful if they're actionable. To be actionable, they must be
understood. Understanding requires communication and documentation.

* An actionable _description_ of the task.
    * Frequently, a short _summary_ of the task, to ease bulk task
      manipulation. Think of the difference between an email subject and an
      email body.
* A _discussion_, consisting of _remarks_ or _comments_, to track the evolving
  understanding alongside the task.

See [speciation](#speciation), below.

## Workflow

"Workflow" describes both the implications of the states a task can be in and
the implications of the transitions between states. Most task trackers are, at
their core, workflow engines of varying sophistication.

Why:

* Improve shared understanding of how tracked tasks are performed.
* Provide clear hand-off points when responsibility shifts.
* Provide insight into which tasks need what kinds of attention.
* Integration points for other behaviour.

States are implicitly time-bounded, and joined to their predecessor and
successor states by transitions.

Task state is decoupled from the real world: the task in a tracker is not the
work it describes.

Elemental states:

* "Open": in this state, the task has not yet been completed. Work may or may
  not be ongoing.
* "Completed": in this state, all work on a task has been completed.
* "Abandoned": in this state, no further work on a task will be performed, but
  the task has not been completed.

Most real-world workflows introduce some intermediate states that tie into
process-related handoffs.

For software, I see these divisions, in various combinations, frequently:

* "Open":
    * "Unverified": further work needs to be done to decide whether the task
      should be completed.
    * "In Development": someone is working on the code and asset changes
      necessary to complete the task. This occasionally subsumes preliminary
      work, too.
    * "In Testing": code and asset changes are ostensibly complete,
      but need testing to validate that the task has been completed
      satisfactorially.
* "Completed":
    * "Development Completed": work (and possibly testing) has been completed
      but the task's results are not yet available to external users.
    * "Released": work has been completed, and external users can see and use
      the results.
* "Abandoned":
    * "Cannot Reproduce": common in bug/defect tasks, to indicate that the
      task doesn't contain enough information to render the bug fixable.
    * "Won't Complete": the task is well-understood and theoretically
      completable, but will not be completed.
    * "Duplicate": the task is identical to, or closely related to, some other
      task, such that completing either would be equivalent to completing
      both.
    * "Invalid": the task isn't relevant, is incompletely described, doesn't
      make sense, or is otherwise not appropriate work for the team using the
      tracker.

None of these are universal.

Transitions show how a task moves from state to state.

* Driven by external factors (dev work leads to tasks being marked completed)
    * Explicit transitions: "mark this task as completed"
    * Implicit transitions: "This commit also completes these tasks"
* Drive external factors (tasks marked completed are emailed to testers)

States implicitly describe a _belief_ or a _desire_ about the future of the
task, which is a human artifact and may be wrong or overly hopeful. Tasks can
transition to "Completed" or "Abandoned" states when the work hasn't actually
been completed or abandoned, or from "Completed" or "Abandoned" to an "Open"
state to note that the work isn't as done as we thought it was. _This is a
feature_ and trackers that assume every transition is definitely true and
final encourage ugly workarounds like duplicating tickets to reopen them.

## Speciation

I mentioned above that bugs are a kind of task. The ways in which bugs are
"different" is interesting:

* Good bugs have a well-defined reproduction case - steps you can follow to
  demonstrate and test them.
* Good bugs have a well-described expected behaviour.
* Good bugs have a well-described actual behaviour.

Being able to support this kind of highly detailed speciation of task types
without either bloating the tracker with extension points (JIRA) or
shoehorning all features into every task type (Redmine) is hard, but
necessary.

Supporting structure helps if it leads to more interesting or efficient ways
of using tasks to drive and understand work.

Bugs are not the only "special" kind of task:

* "Feature" tasks show up frequently, and speciate on having room for
  describing specs and scope.
* "Support ticket" tasks show up in a few trackers, and speciate dramatically
  as they tend to be tasks describing the work of a single incident rather
  than tasks describing the work on some shared aspect, so they tend to pick
  up fields for relating tickets to the involved parties. (Arguably, incident
  tickets have needs so drastically different that you should use a dedicated
  incident-management tool, not a task/bug tracker.)

Other kinds are possible, and you've probably seen them in the wild.

Ideally, speciation happens to support _widespread_ specialized needs. Bug
repro is a good example; every task whose goal is to fix a defect should
include a clear understanding of the defect, both to allow it to be fixed and
to allow it to be tested. Adding specialized data for bugs supports that by
encouraging clearer, more structured descriptions of the defect (with implicit
"fix this" as the task).
