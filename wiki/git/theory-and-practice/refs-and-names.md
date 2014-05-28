# Refs and Names

Git's [object system](objects) stores most of the data for projects tracked in
Git, but only provides SHA-1 hashes. This is basically useless if you want to
make practical use of Git, so Git also has a naming mechanism called “refs”
that provide human-meaningful names for objects.

There are two kinds of refs:

* “Normal” refs, which are names that resolve directly to SHA-1 hashes. These
  are the vast majority of refs in most repositories.

* “Symbolic” refs, which are names that resolve to other refs. In most
  repositories, only a few of these appear. (Circular references are possible
  with symbolic refs. Git will refuse to resolve these.)

Anywhere you could use a SHA-1, you can use a ref instead. Git interprets them
identically, after resolving the ref down to the SHA-1.

## Namespaces

Every operation in Git that uses a name of some sort, including branching
(branch names), tagging (tag names), fetching (remote-tracking branch names),
and pushing (many kinds of name), expands those names to refs, using a
namespace convention. The following namespaces are common:

* `refs/heads/NAME`: branches. The branch name is the ref name with
  `refs/heads/` removed. Names generally point to commits.

* `refs/remotes/REMOTE/NAME`: “remote-tracking” branches. These are maintained
  in tandem by `git remote` and `git fetch`, to cache the state of other
  repositories. Names generally point to commits.

* `refs/tags/NAME`: tags. The tag name is the ref name with `refs/heads/`
  removed. Names generally point to commits or tag objects.

* `refs/bisect/STATE`: `git bisect` markers for known-good and known-bad
  revisions, from which the rest of the bisect state can be derived.

There are also a few special refs directly in the `refs/` namespace, most
notably:

* `refs/stash`: The most recent stash entry, as maintained by `git stash`.
  (Other stash entries are maintained by a separate system.) Names generally
  point to commits.

Tools can invent new refs for their own purposes, or manipulate existing refs;
the convention is that tools that use refs (which is, as I said, most of them)
respect the state of the ref as if they'd created that state themselves,
rather than sanity-checking the ref before using it.

## Special refs

There are a handful of special refs used by Git commands for their own
operation. These refs do _not_ begin with `refs/`:

* `HEAD`: the “current” commit for most operations. This is set when checking
  out a commit, and many revision-related commands default to `HEAD` if not
  given a revision to operate on. `HEAD` can either be a symbolic ref
  (pointing to a branch ref) or a normal ref (pointing directly to a commit),
  and is very frequently a symbolic ref.

* `MERGE_HEAD`: during a merge, `MERGE_HEAD` resolves to the commit whose
  history is being merged.

* `ORIG_HEAD`: set by operations that change `HEAD` in potentially destructive
  ways by resolving `HEAD` before making the change.

* `CHERRY_PICK_HEAD` is set during `git cherry-pick` to the commit whose
  changes are being copied.

* `FETCH_HEAD` is set by the forms of `git fetch` that fetch a single ref, and
  points to the commit the fetched ref pointed to.

## Examining and manipulating refs

The `git show-ref` command will list the refs in namespaces under `refs` in
your repository, printing the SHA-1 hashes they resolve to. Pass `--head` to
also include `HEAD`.

The following commands can be used to manipulate refs directly:

* `git update-ref <ref> <sha1>` forcibly sets `<ref>` to the passed `<sha1>`.

* `git update-ref -d <ref>` deletes a ref.

* `git symbolic-ref <ref>` prints the target of `<ref>`, if `<ref>` is a
  symbolic ref. (It will fail with an error message for normal refs.)

* `git symbolic-ref <ref> <target>` forcibly makes `<ref>` a symbolic ref
  pointing to `<target>`.

Additionally, you can see what ref a given name resolves to using `git
rev-parse --symbolic-full-name <name>` or `git show-ref <name>`.
