# Life With Pull Requests

I've been party to a number of discussions with folks contributing to
pull-request-based projects on Github (and other hosts, but mostly Github).
Because of Git's innate flexibility, there are lots of ways to work with pull
requests. Here's mine.

I use a couple of naming conventions here that are not stock `git`:

origin
:   The repository to which you _publish_ proposed changes

upstream
:   The repository from which you receive ongoing development, and which will
    receive your changes.

## One-time setup

Do these things once, when starting out on a project. Keep the results around
for later.

I'll be referring to the original project repository as `upstream` and
pretending its push URL is `UPSTREAM-URL` below. In real life, the URL will
often be something like `git@github.com:someguy/project.git`.

### Fork the project

Use the repo manager's forking tool to create a copy of the project in your
own namespace. This generally creates your copy with a bunch of useless tat;
feel free to ignore all of this, as the only purpose of this copy is to
provide somewhere for _you_ to publish _your_ changes.

We'll be calling this repository `origin` later. Assume it has a URL, which
I'll abbreviate `ORIGIN-URL`, for `git push` to use.

(You can leave this step for later, but if you know you're going to do it, why
not get it out of the way?)

### Clone the project and configure it

You'll need a clone locally to do work in. Create one from `origin`:

    git clone ORIGIN-URL some-local-name

While you're here, `cd` into it and add the original project as a remote:

    cd some-local-name
    git remote add upstream UPSTREAM-URL

## Feature process

### Create a new feature branch locally

We use `upstream`'s `master` branch here, so that your feature includes all of
`upstream`'s state initially. We also need to make sure our local cache of
`upstream`'s state is correct:

    git fetch upstream
    git checkout upstream/master -b my-feature

### Do work

If you need my help here, stop now.

### Integrate upstream changes

If you find yourself needing something that's been added upstream, use
_rebase_ to integrate it to avoid littering your feature branch with
"meaningless" merge commits.

    git checkout my-feature
    git fetch upstream
    git rebase upstream/master

### Publish your branch

When you're "done", publish your branch to your personal repository:

    git push origin my-feature

Then visit your copy in your repo manager's web UI and create a pull request
for `my-feature`.

### Integrating feedback

Very likely, your proposed changes will need work. If you use history-editing
to integrate feedback, you will need to use `--force` when updating the
branch:

    git push --force origin my-feature

This is safe provided two things are true:

1. **The branch has not yet been merged to the upstream repo.**
2. You are only force-pushing to your fork, not to the upstream repo.

Generally, no other users will have work based on your pull request, so
force-pushing history won't cause problems.
