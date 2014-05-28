# Git Survival Guide

I think the `git` UI is pretty awful, and encourages using Git in ways that
will screw you. Here are a few things I've picked up that have saved my bacon.

* You will inevitably need to understand Git's “internals” to make use of it
  as an SCM tool. Accept this early. If you think your SCM tool should not
  expose you to so much plumbing, [don't](http://mercurial.selenic.com)
  [use](http://bazaar.canonical.com) [Git](http://subversion.apache.org).
    * Git weenies will claim that this plumbing is what gives Git all of its
      extra power. This is true; it gives Git the power to get you out of
      situations you wouldn't be in without Git.
* `git log --graph --decorate --oneline --color --all`
* Run `git fetch` habitually. Stale remote-tracking branches lead to sadness.
* `git push` and `git pull` are **not symmetric**. `git push`'s
  opposite operation is `git fetch`. (`git pull` is equivalent to `git fetch`
  followed by `git merge`, more or less).
* [Git configuration values don't always have the best defaults](config).
* The upstream branch of `foo` is `foo@{u}`. The upstream branch of your
  checked-out branch is `HEAD@{u}` or `@{u}`. This is documented in `git help
  revisions`.
* You probably don't want to use a merge operation (such as `git pull`) to
  integrate upstream changes into topic branches. The resulting history can be
  very confusing to follow, especially if you integrate upstream changes
  frequently.
    * You can leave topic branches “real” relatively safely. You can do
      a test merge to see if they still work cleanly post-integration without
      actually integrating upstream into the branch permanently.
    * You can use `git rebase` or `git pull --rebase` to transplant your
      branch to a new, more recent starting point that includes the changes
      you want to integrate. This makes the upstream changes a permanent part
      of your branch, just like `git merge` or `git pull` would, but generates
      an easier-to-follow history. Conflict resolution will happen as normal.
* Example test merge, using `origin/master` as the upstream branch and `foo`
  as the candidate for integration:

        git fetch origin
        git checkout origin/master -b test-merge-foo
        git merge foo
        # run tests, examine files
        git diff origin/master..HEAD

    To discard the test merge, delete the branch after checking out some other
    branch:

        git checkout foo
        git branch -D test-merge-foo

    You can combine this with `git rerere` to save time resolving conflicts in
    a later “real,” permanent merge.

* You can use `git checkout -p` to build new, tidy commits out of a branch
  laden with “wip” commits:

        git fetch
        git checkout $(git merge-base origin/master foo) -b foo-cleaner-history
        git checkout -p foo -- paths/to/files
        # pick out changes from the presented patch that form a coherent commit
        # repeat 'git checkout -p foo --' steps for related files to build up
        # the new commit
        git commit
        # repeat 'git checkout -p foo --' and 'git commit' steps until no diffs remain

    * Gotcha: `git checkout -p` will do nothing for files that are being
      created. Use `git checkout`, instead, and edit the file if necessary.
      Thanks, Git.
    * Gotcha: The new, clean branch must diverge from its upstream branch
      (`origin/master`, in the example above) at exactly the same point, or
      the diffs presented by `git checkout -p foo` will include chunks that
      revert changes on the upstream branch since the “dirty” branch was
      created. The easiest way to find this point is with `git merge-base`.

## Useful Resources

That is, resoures that can help you solve problems or understand things, not
resources that reiterate the man pages for you.

* Sitaram Chamarty's [git concepts
  simplified](http://sitaramc.github.com/gcs/)
* Tv's [Git for Computer
  Scientists](http://eagain.net/articles/git-for-computer-scientists)
