# Writing Good Commit Messages

Rule zero: “good” is defined by the standards of the project you're on. Have a
look at what the existing messages look like, and try to emulate that first
before doing anything else.

Having said that, here are some things that will help your commit messages be
useful later:

* Treat the first line of the message as a one-sentence summary. Most SCM
  systems have an “overview” command that shows shortened commit messages in
  bulk, so making the very beginning of the message meaningful helps make
  those modes more useful for finding specific commits. _It's okay for this to
  be a “what” description_ if the rest of the message is a “why” description.

* Fill out the rest of the message with prose outlining why you made the
  change. The guidelines for a good “why” message are the same as [the
  guidelines for good comments](comments), but commit messages can be
  signifigantly longer. Don't bother reiterating the contents of the change in
  detail; anyone who needs that can read the diff themselves.

* If you use an issue tracker (and you should), include whatever issue-linking
  notes it supports right at the start of the message, where it'll be visible
  even in shortlogs. If your tracker has absurdly long issue-linking syntax,
  or doesn't support issue links in commits at all, include a short issue
  identifier at the front of the message and put the long part somewhere out
  of the way, such as on a line of its own at the end of the message.

* Pick a tense and a mood and stick with them. Reading one commit with a
  present-tense imperative message (“Add support for PNGs”) and another commit
  with a past-tense narrative message (“Fixed bug in PNG support”) is
  distracting.

* If you need rich commit messages (links, lists, and so on), pick one markup
  language and stick with it. It'll be easier to write useful commit
  formatters if you only have to deal with one syntax, rather than four.
  (Personally, I use Markdown on projects I control.)

    * This also applies to line-wrapping: either hard-wrap everywhere, or
      hard-wrap nowhere.

## An Example

    commit 842e6c5f41f6387781fcc84b59fac194f52990c7
    Author: Owen Jacobson <owen.jacobson@grimoire.ca>
    Date:   Fri Feb 1 16:51:31 2013 -0500

        DS-37: Add support for privileges, and create a default privileged user.

        This change gives each user a (possibly empty) set of privileges. Privileges
        are mediated by roles in the following ways:

        * Each user is a member of zero or more roles.
        * Each role implies membership in zero or more roles. If role A implies role
          B, then a member of role A is also a transitive member of role B. This
          relationship is transitive: if A implies B and B implies C, then A implies
          C. This graph should not be cyclic, but it's harmless if it is.
        * Each role grants zero or more privileges.

        A user's privileges are the union of all privileges of all roles the user is a
        member of, either directly or transitively.

        Obviously, a role that implies no other roles and grants no priveleges is
        meaningless to the authorization system. This may be useful for "advisory"
        roles meant for human consumption.

        This also introduces a user with the semi-magical name '*admin' (chosen
        because asterisks cannot collide with player-chosen usernames), and the group
        '*superuser' that is intended to hold all privileges. No privileges are yet
        defined.
