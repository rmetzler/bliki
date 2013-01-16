# git-config Settings You Want

Git comes with some fairly [lkml](http://www.tux.org/lkml/)-specific
configuration defaults. You should fix this. All of the items below can be set
either for your entire login account (`git config --global`) or for a specific
repository (`git config`).

Full documentation is under `git help config`, unless otherwise stated.

* `git config user.name 'Your Full Name'` and `git config user.email
  'your-email@example.com'`, obviously.

* `git config push.default simple` - the default behaviour (called `matching`)
  of an unqualified `git push` is to identify pairs of branches by name and
  push all matches from your local repository to the remote. Given that
  branches have explicit "upstream" configuration identifying which, if any,
  branch in which, if any, remote they're associated with, this is dumb. The
  `simple` mode pushes the current branch to its upstream remote, if and only
  if the local branch name and the remote branch name match _and_ the local
  branch tracks the remote branch. Requires Git 1.8 or later; will be the
  default in Git 2.0. (For older versions of Git, use `upstream` instead,
  which does not require that branch names match.)

* `git config merge.defaultToUpstream true` - causes an unqualified `git
  merge` to merge the current branch's configured upstream branch, rather than
  being an error. (`git rebase` always has this behaviour. Consistent!) You
  should still merge thoughtfully.

* `git config rebase.autosquash true` - causes `git rebase -i` to parse magic
  comments created by `git commit --squash=some-hash` and `git commit
  --fixup=some-hash` and reorder the commit list before presenting it for
  further editing. See the descriptions of "squash" and "fixup" in `git help
  rebase` for details; autosquash makes amending commits other than the most
  recent easier and less error-prone.

* `git config branch.autosetupmerge always` - newly-created branches whose
  start point is a branch (`git checkout master -b some-feature`, `git branch
  some-feature origin/develop`, and so on) will be configured to have the
  start point branch as their upstream. By default (with `true` rather than
  `always`) this only happens when the start point is a remote-tracking
  branch.

* `git config rerere.enabled true` - enable "reuse recorded resolution". The
  `git help rerere` docs explain it pretty well, but the short version is that
  git can record how you resolve conflicts during a "test" merge and reuse the
  same approach when resolving the same conflict later, in a "real" merge.

## For advanced users

A few things are nice when you're getting started, but become annoying when
you no longer need them.

* `git config advice.detachedHead` - if you already understand the difference
  between having a branch checked out and having a commit checked out, and
  already understand what "detatched head" means, the warning on every `git
  checkout ...some detatched thing...` isn't helping anyone. This is also
  useful repositories used for deployment, where specific commits (from tags,
  for example) are regularly checked out.
