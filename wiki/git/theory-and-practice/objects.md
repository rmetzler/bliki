# Objects

Git's basest level is a storage and naming system for things Git calls
“objects.” These objects hold the bulk of the data about files and projects
tracked by Git: file contents, directory trees, commits, and so on. Every
object is identified by a SHA-1 hash, which is derived from its contents.

SHA-1 hashes are obnoxiously long, so Git allows you to substitue any unique
prefix of a SHA-1 hash, so long as it's at least four characters long. If the
hash `0b43b9e3e64793f5a222a644ed5ab074d8fa1024` is present in your repository,
then Git commands will understand `0b43`, `0b43b9`, and other patterns to all
refer to the same object, so long as no other object has the same SHA-1
prefix.

## Blobs

The contents of every file that's ever been stored in a Git repository are
stored as `blob` objects. These objects are very simple: they contain the file
contents, byte for byte.

## Trees

File contents (and trees, and Other Things we'll get to later) are tied
together into a directory structure by `tree` objects. These objects contain a
list of records, with one child per record. Each record contains a permissions
field corresponding to the POSIX permissions mask of the object, a type, a
SHA-1 for another object, and a name.

A directory containing only files might be represented as the tree

    100644 blob 511542ad6c97b28d720c697f7535897195de3318	config.md
    100644 blob 801ddd5ae10d6282bbf36ccefdd0b052972aa8e2	integrate.md
    100644 blob 61d28155862607c3d5d049e18c5a6903dba1f85e	scratch.md
    100644 blob d7a79c144c22775239600b332bfa120775bab341	survival.md

while a directory with subdirectories would also have some `tree` children:

    040000 tree f57ef2457a551b193779e21a50fb380880574f43	12factor
    040000 tree 844697ce99e1ef962657ce7132460ad7a38b7584	authnz
    100644 blob 54795f9b774547d554f5068985bbc6df7b128832	cool-urls-can-change.md
    040000 tree fc3f39eb5d1a655374385870b8be56b202be7dd8	dev
    040000 tree 22cbfb2c1d7b07432ea7706c36b0d6295563c69c	devops
    040000 tree 0b3e63b4f32c0c3acfbcf6ba28d54af4c2f0d594	git
    040000 tree 5914fdcbd34e00e23e52ba8e8bdeba0902941d3f	java
    040000 tree 346f71a637a4f8933dc754fef02515a8809369c4	mysql
    100644 blob b70520badbb8de6a74b84788a7fefe64a432c56d	packaging-ideas.md
    040000 tree 73ed6572345a368d20271ec5a3ffc2464ac8d270	people

## Commits

Blobs and trees are sufficient to store arbitrary directory trees in Git, and
you could use them that way, but Git is mostly used as a revision-tracking
system. Revisions and their history are represented by `commit` objects, which contain:

    * The SHA-1 hash of the root `tree` object of the commit,
    * Zero or more SHA-1 hashes for parent commits,
    * The name and email address of the commit's “author,”
    * The name and email address of the commit's “committer,”
    * Timestamps representing when the commit was authored and committed, and
    * A commit message.

Commit objects' parent references form a directed acyclic graph; the subgraph
reachable from a specific commit is that commit's _history_.

When working with Git's user interface, commit parents are given in a
predictable order determined by the `git checkout` and `git merge` commands.

## Tags

Git's revision-tracking system supports “tags,” which are stable names for
specific configurations. It also, uniquely, supports a concept called an
“annotated tag,” represented by the `tag` object type. These annotated tag
objects contain

    * The type and SHA-1 hash of another object,
    * The name and email address of the person who created the tag,
    * A timestamp representing the moment the tag was created, and
    * A tag message.

## Anonymity

There's a general theme to Git's object types: no object knows its own name.
Every object only has a name in the context of some containing object, or in
the context of [Git's refs mechanism](refs-and-names), which I'll get to
shortly. This means that the same `blob` object can be reused for multiple
files (or, more probably, the same file in multiple commits), if they happen
to have the same contents.

This also applies to tag objects, even though their role is part of a system
for providing stable, meaningful names for commits.

## Examining objects

* `git cat-file <type> <sha1>`: decodes the object `<sha1>` and prints its
  contents to stdout. This prints the object's contents in their raw form,
  which is less than useful for `tree` objects.

* `git cat-file -p <sha1>`: decodes the object `<sha1>` and pretty-prints it.
  This pretty-printing stays close to the underlying disk format; it's most
  useful for decoding `tree` objects.

* `git show <sha1>`: decodes the object `<sha1>` and formats its contents to
  stdout. For blobs, this is identical to what `git cat-file blob` would do,
  but for trees, commits, and tags, the output is reformated to be more
  readable.

## Storage

Objects are stored in two places in Git: as “loose objects,” and in “pack
files.” Newly-created objects are initially loose objects, for ease of
manipulation; transferring objects to another repository or running certain
administrative commands can cause them to be placed in pack files for faster
transfer and for smaller storage.

Loose objects are stored directly on the filesystem, in the Git repository's
`objects` directory. Git takes a two-character prefix off of each object's
SHA-1 hash, and uses that to pick a subdirectory of `objects` to store the
object in. The remainder of the hash forms the filename. Loose objects are
compressed with zlib, to conserve space, but the resulting directory tree can
still be quite large.

Packed objects are stored together in packed files, which live in the
repository's `objects/pack` directory. These packed files are both compressed
and delta-encoded, allowing groups of similar objects to be stored very
compactly.
