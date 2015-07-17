# Merging Structural Changes

In 2008, a project I was working on set out to reinvent their build process,
migrating from a mass of poorly-written Ant scripts to Maven and reorganizing
their source tree in the process. The development process was based on having
a branch per client, so there was a lot of ongoing development on the original
layout for clients that hadn't been migrated yet. We discovered that our
version control tool, [Subversion](http://subversion.tigris.org/), was unable
to merge the changes between client branches on the old structure and the
trunk on the new structure automatically.

Curiousity piqued, I cooked up a script that reproduces the problem and
performs the merge from various directions to examine the results. Subversion,
sadly, performed dismally: none of the merge scenarios tested retained content
changes when merging structural changes to the same files.

## The Preferred Outcome

![Both changes survive the
merge.](/media/dev/merging-structural-changes/ideal-merge-results.png)

The diagram above shows a very simple source tree with one directory, `dir-a`,
containing one file with two lines in it. On one branch, the file is modified
to have a third line; on another branch, the directory is renamed to `dir-b`.
Then, both branches are merged, and the resulting tree contains both sets of
changes: the file has three lines, and the directory has a new name.

This is the preferred outcome, as no changes are lost or require manual
merging.

## Subversion

![Subversion loses the content
change.](/media/dev/merging-structural-changes/subversion-merge-results.png)

There are two merge scenarios in this diagram, with almost the same outcome.
On the left, a working copy of the branch where the file's content changed is
checked out, then the changes from the branch where the structure changed are
merged in. On the right, a working copy of the branch where the structure
changed is checked out, then the changes from the branch where the content
changed are merged in. In both cases, the result of the merge has the new
directory name, and the original file contents. In one case, the merge
triggers a rather opaque warning about a “missing file”; in the other, the
merge silently ignores the content changes.

This is a consequence of the way Subversion implements renames and copies.
When Subversion assembles a changeset for committing to the repository, it
comes up with a list of primitive operations that reproduce the change. There
is no primitive that says “this object was moved,” only primitives which say
“this object was deleted” or “this object was added, as a copy of that
object.” When you move a file in Subversion, those two operations are
scheduled. Later, when Subversion goes to merge content changes to the
original file, all it sees is that the file has been deleted; it's completely
unaware that there is a new name for the same file.

This would be fairly easy to remedy by adding a “this object was moved to that
object” primitive to the changeset language, and [a bug report for just such a
feature](http://subversion.tigris.org/issues/show_bug.cgi?id=898) was filed in
2002. However, by that time Subversion's repository and changeset formats had
essentially frozen, as Subversion was approaching a 1.0 release and more
important bugs _without_ workarounds were a priority.

There is some work going on in Subversion 1.6 to handle tree conflicts (the
kind of conflicts that come from this kind of structural change) more
sensibly, which will cause the two merges above to generate a Conflict result,
which is not as good as automatically merging it but far better than silently
ignoring changes.

## Mercurial

![Mercurial preserves the content
change.](/media/dev/merging-structural-changes/mercurial-merge-results.png)

Interestingly, there are tools which get this merge scenario right: the
diagram above shows how [Mercurial](http://www.selenic.com/mercurial/) handles
the same two tests. Since its changeset language does include an “object
moved” primitive, it's able to take a content change for `dir-a/file` and
apply it to `dir-b/file` if appropriate.

## Git

Git also gets this scenario right, _usually_. Unlike Mercurial, Git does not
track file copies or renames in its commits at all, prefering to infer them by
content comparison every time it performs a move-aware operation, such as a
merge.
