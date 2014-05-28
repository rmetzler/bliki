# Git Is Not Magic

I'm bored. Let's make a git repository out of whole cloth.

Git repos are stored in .git:

    fakegit$ mkdir .git

They have a “symbolic ref” (which are text files, see [`man
git-symbolic-ref`](http://jk.gs/git-symbolic-ref.html)) named `HEAD`, pointing
to the currently checked-out branch. Let's use `master`. Branches are refs
under `refs/heads` (see [`man git-branch`](http://jk.gs/git-branch.html)):

    fakegit ((unknown))$ echo 'ref: refs/heads/master' > .git/HEAD

The have an object database and a refs database, both of which are simple
directories (see [`man
gitrepository-layout`](http://jk.gs/gitrepository-layout.html) and [`man
gitrevisions`](http://jk.gs/gitrevisions.html)). Let's also enable the reflog,
because it's a great safety net if you use history-editing tools in git:

    fakegit ((ref: re...))$ mkdir .git/refs .git/objects .git/logs
    fakegit (master #)$

Now `__git_ps1`, at least, is convinced that we have a working git repository.
Does it work?

    fakegit (master #)$ echo 'Hello, world!' > hello.txt
    fakegit (master #)$ git add hello.txt
    fakegit (master #)$ git commit -m 'Initial commit'
    [master (root-commit) 975307b] Initial commit
    1 file changed, 1 insertion(+)
    create mode 100644 hello.txt
    
    fakegit (master)$ git log
    commit 975307ba0485bff92e295e3379a952aff013c688
    Author: Owen Jacobson <owen.jacobson@grimoire.ca>
    Date:   Wed Feb 6 10:07:07 2013 -0500
    
        Initial commit

[Eeyup](https://www.youtube.com/watch?v=3VwVpaWUu30).

-----

Should you do this? **Of course not.** Anywhere you could run these commands,
you could instead run `git init` or `git clone`, which set up a number of
other structures, including `.git/config` and any unusual permissions options.
The key part here is that a directory's identity as “a git repository” is
entirely a function of its contents, not of having been blessed into being by
`git` itself.

You can infer a lot from this: for example, you can infer that it's “safe” to
move git repositories around using FS tools, or to back them up with the same
tools, for example. This is not as obvious to everyone as you might hope; people 
