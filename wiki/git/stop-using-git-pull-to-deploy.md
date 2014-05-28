# Stop using `git pull` for deployment!

## The problem

* You have a Git repository containing your project.
* You want to “deploy” that code when it changes.
* You'd rather not download the entire project from scratch for each
  deployment.

## The antipattern

“I know, I'll use `git pull` in my deployment script!”

Stop doing this. Stop teaching other people to do this. It's wrong, and it
will eventually lead to deploying something you didn't want.

Deployment should be based on predictable, known versions of your code.
Ideally, every deployable version has a tag (and you deploy exactly that tag),
but even less formal processes, where you deploy a branch tip, should still be
deploying exactly the code designated for release. `git pull`, however, can
introduce new commits.

`git pull` is a two-step process:

1. Fetch the current branch's designated upstream remote, to obtain all of the
   remote's new commits.
2. Merge the current branch's designated upstream branch into the current
   branch.

The merge commit means the actual deployed tree might _not_ be identical to
the intended deployment tree. Local changes (intentional or otherwise) will be
preserved (and merged) into the deployment, for example; once this happens,
the actual deployed commit will _never_ match the intended commit.

`git pull` will approximate the right thing “by accident”: if the current
local branch (generally `master`) for people using `git pull` is always clean,
and always tracks the desired deployment branch, then `git pull` will update
to the intended commit exactly. This is pretty fragile, though; many git
commands can cause the local branch to diverge from its upstream branch, and
once that happens, `git pull` will always create new commits. You can patch
around the fragility a bit using the `--ff-only` option, but that only tells
you when your deployment environment has diverged and doesn't fix it.

## The right pattern

Quoting [Sitaram Chamarty](http://gitolite.com/the-list-and-irc/deploy.html):

> Here's what we expect from a deployment tool. Note the rule numbers --
> we'll be referring to some of them simply by number later.
>
> 1. All files in the branch being deployed should be copied to the
>     deployment directory.
>
> 2. Files that were deleted in the git repo since the last deployment
>     should get deleted from the deployment directory.
>
> 3. Any changes to tracked files in the deployment directory after the
>     last deployment should be ignored when following rules 1 and 2.
>
>     However, sometimes you might want to detect such changes and abort if
>     you found any.
>
> 4. Untracked files in the deploy directory should be left alone.
>
>     Again, some people might want to detect this and abort the deployment.

Sitaram's own documentation talks about how to accomplish these when
“deploying” straight out of a bare repository. That's unwise (not to mention
impractical) in most cases; deployment should use a dedicated clone of the
canonical repository.

I also disagree with point 3, preferring to keep deployment-related changes
outside of tracked files. This makes it much easier to argue that the changes
introduced to configure the project for deployment do not introduce new bugs
or other surprise features.

My deployment process, given a dedicated clone at `$DEPLOY_TREE`, is as
follows:

    cd "${DEPLOY_TREE}"
    git fetch --all
    git checkout --force "${TARGET}"
    # Following two lines only required if you use submodules
    git submodule sync
    git submodule update --init --recursive
    # Follow with actual deployment steps (run fabric/capistrano/make/etc)

`$TARGET` is either a tag name (`v1.2.1`) or a remote branch name
(`origin/master`), but could also be a commit hash or anything else Git
recognizes as a revision. This will detach the head of the `$DEPLOY_TREE`
repository, which is fine as no new changes should be authored in this
repository (so the local branches are irrelevant). The warning Git emits when
`HEAD` becomes detached is unimportant in this case.

The tracked contents of `$DEPLOY_TREE` will end up identical to the desired
commit, discarding local changes. The pattern above is very similar to what
most continuous integration servers use when building from Git repositories,
for much the same reason.
