# Notes Towards Detached Signatures in Git

Git supports a limited form of object authentication: specific object
categories in Git's internal model can have [GPG](/gpg/terrible) signatures
embedded in them, allowing the authorship of the objects to be verified using
[GPG](/gpg/cool)'s underlying trust model. Tag signatures can be used to
verify the authenticity and integrity of the _snapshot associated with a
tag_, and the authenticity of the tag itself, filling a niche broadly similar
to code signing in binary distribution systems. Commit signatures can be used
to verify the authenticity of the _snapshot associated with the commit_, and
the authorship of the commit itself. (Conventionally, commit signatures are
assumed to also authenticate either the entire line of history leading to a
commit, or the diff between the commit and its first parent, or both.)

Git's existing system has some tradeoffs.

* Signatures are embedded within the objects they sign. The signature is part
  of the object's identity; since Git is content-addressed, this means that
  an object can neither be retroactively signed nor retroactively stripped of
  its signature without modifying the object's identity. Git's distributed
  model means that these sorts of identity changes are both complicated and
  easily detected.

* Commit signatures are second-class citizens. They're a relatively recent
  addition to the Git suite, and both the implementation and the social
  conventions around them continue to evolve.

* Only some objects can be signed. While Git has relatively weak rules about
  workflow, the signature system assumes you're using one of Git's more
  widespread workflows by limiting your options to at most one signature, and
  by restricting signatures to tags and commits (leaving out blobs, trees,
  and refs).

I believe it would be useful from an authentication standpoint to add
"detached" signatures to Git, to allow users to make these tradeoffs
differently if desired. These signatures would be stored as separate (blob)
objects in a dedicated `refs` namespace, supporting retroactive signatures,
multiple signatures for a given object, "policy" signatures, and
authentication of arbitrary objects.

The following notes are partially guided by Git's one existing "detached
metadata" facility, `git notes`. Similarities are intentional; divergences
will be noted where appropriate. Detached signatures are meant to
interoperate with existing Git workflow as much as possible: in particular,
they can be fetched and pushed like any other bit of Git metadata.

A detached signature cryptographically binds three facts together into an
assertion whose authenticity can be checked by anyone with access to the
signatory's keys:

1. An object (in the Git sense; a commit, tag, tree, or blob),
2. A policy label, and
3. A signatory (a person or agent making the assertion).

These assertions can be published separately from or in tandem with the
objects they apply to.

## Policies

Taking a hint from Monotone, every signature includes a "policy" identifying
how the signature is meant to be interpreted. Policies are arbitrary strings;
their meaning is entirely defined by tooling and convention, not by this
draft.

This draft uses a single policy, `author`, for its examples. A signature
under the `author` policy implies that the signatory had a hand in the
authorship of the designated object. (This is compatible with existing
interpretations of signed tags and commits.) (Authorship under this model is
strictly self-attested: you can claim authorship of anything, and you cannot
assert anyone else's authorship.)

The Monotone documentation suggests a number of other useful policies related
to testing and release status, automated build results, and numerous other
factors. Use your imagination.

## What's In A Signature

Detached signatures cover the disk representation of an object, as given by

    git cat-file <TYPE> <SHA1>

For most of Git's object types, this means that the signed content is plain
text. For `tree` objects, the signed content is the awful binary
representation of the tree, _not_ the pretty representation given by `git
ls-tree` or `git show`.

Detached signatures include the "policy" identifier in the signed content, to
prevent others from tampering with policy choices via `refs` hackery. (This
will make more sense momentarily.) The policy identifier is prepended to the
signed content, terminated by a zero byte (as with Git's own type
identifiers, but without a length field as length checks are performed by
signing and again when the signature is stored in Git).

To generate the _complete_ signable version of an object, use something
equivalent to the following shell snippet:

    # generate-signable POLICY TYPE SHA1
    function generate-signable() {
        echo -n "$1"
        SOMETHING OUTPUTTING A NUL HERE
        git cat-file "$2" "$3"
    }

(In the process of writing this, I discovered how hard it is to get Unix's
C-derived shell tools to emit a zero byte.)

## Signature Storage and Naming

We assume that a userid will sign an object at most once.

Each signature is stored in an independent blob object in the repository it
applies to. The signature object (described above) is stored in Git, and its
hash recorded in `refs/signatures/<POLICY>/<SUBJECT SHA1>/<SIGNER KEY
FINGERPRINT>`.

    # sign POLICY TYPE SHA1 FINGERPRINT
    function sign() {
        local SIG_HASH=$(
            generate-signable "$@" |
            gpg --batch --no-tty --sign -u "$4" |
            git hash-object --stdin -w -t blob
        )
        git update-ref "refs/signatures/$1/$3/$4"
    }

Stored signatures always use the complete fingerprint to identify keys, to
minimize the risk of colliding key IDs while avoiding the need to store full
keys in the `refs` naming hierarchy.

The policy name can be reliably extracted from the ref, as the trailing part
has a fixed length (in both path segments and bytes) and each ref begins with
a fixed, constant prefix `refs/signatures/`.

## Signature Verification

Given a signature ref as described above, we can verify and authenticate the
signature and bind it to the associated object and policy by performing the
following check:

1. Pick apart the ref into policy, SHA1, and key fingerprint parts.
2. Reconstruct the signed body as above, using the policy name extracted from
   the ref.
3. Retrieve the signature from the ref and combine it with the object itself.
4. Verify that the policy in the stored signature matches the policy in the
   ref.
5. Verify the signature with GPG:

        # verify-gpg POLICY TYPE SHA1 FINGERPRINT
        verify-gpg() {
            {
                git cat-file "$2" "$3"
                git cat-file "refs/signatures/$1/$3/$4"
            } | gpg --batch --no-tty --verify
        }

6. Verify the key fingerprint of the signing key matches the key fingerprint
   in the ref itself.

The specific rules for verifying the signature in GPG are left up to the user
to define; for example, some sites may want to auto-retrieve keys and use a
web of trust from some known roots to determine which keys are trusted, while
others may wish to maintain a specific, known keyring containing all signing
keys for each policy, and skip the web of trust entirely. This can be
accomplished via `git-config`, given some work, and via `gpg.conf`.

## Distributing Signatures

Since each signature is stored in a separate ref, and since signatures are
_not_ expected to be amended once published, the following refspec can be
used with `git fetch` and `git push` to distribute signatures:

    refs/signatures/*:refs/signatures/*

Note the lack of a `+` decoration; we explicitly do not want to auto-replace
modified signatures, normally; explicit user action should be required.

## Workflow Notes

There are two verification workflows for signatures: "static" verification,
where the repository itself already contains all the refs and objects needed
for signature verification, and "pre-receive" verification, where an object
and its associated signature may be being uploaded at the same time.

_It is impractical to verify signatures on the fly from an `update` hook_.
Only `pre-receive` hooks can usefully accept or reject ref changes depending
on whether the push contains a signature for the pushed objects. (Git does
not provide a good mechanism for ensuring that signature objects are pushed
before their subjects.) Correctly verifying object signatures during
`pre-receive` regardless of ref order is far too complicated to summarize
here.

## Attacks

### Lies of Omission

It's trivial to hide signatures by deleting the signature refs. Similarly,
anyone with access to a repository can delete any or all detached signatures
from it without otherwise invalidating the signed objects.

Since signatures are mostly static, sites following the recommended no-force
policy for signature publication should only be affected if relatively recent
signatures are deleted. Older signatures should be available in one or more
of the repository users' loca repositories; once created, a signature can be
legitimately obtained from anywhere, not only from the original signatory.

The signature naming protocol is designed to resist most other forms of
assertion tampering, but straight-up omission is hard to prevent.

### Unwarranted Certification

The `policy` system allows any signatory to assert any policy. While
centralized signature distribution points such as "release" repositories can
make meaningful decisions about which signatures they choose to accept,
publish, and propagate, there's no way to determine after the fact whether a
policy assertion was obtained from a legitimate source or a malicious one
with no grounds for asserting the policy.

For example, I could, right now, sign an `all-tests-pass` policy assertion
for the Linux kernel. While there's no chance on Earth that the LKML team
would propagate that assertion, if I can convince you to fetch signatures
from my repository, you will fetch my bogus assertion. If `all-tests-pass` is
a meaningful policy assertion for the Linux kernel, then you will have very
few options besides believing that I assert that all tests have passed.

### Ambigiuous Policy

This is an ongoing problem with crypto policy systems and user interfaces
generally, but this design does _nothing_ to ensure that policies are
interpreted uniformly by all participants in a repository. In particular,
there's no mechanism described for distributing either prose or programmatic
policy definitions and checks. All policy information is out of band.

Git already has ambiguity problems around commit signing: there are multiple
ways to interpret a signature on a commit:

1. I assert that this snapshot and commit message were authored as described
   in this commit's metadata. (In this interpretation, the signature's
   authenticity guarantees do _not_ transitively apply to parents.)

2. I assert that this snapshot and commit message were authored as described
   in this commit's metadata, based on exactly the parent commits described.
   (In this interpretation, the signature's authenticity guarantees _do_
   transitively apply to parents. This is the interpretation favoured by XXX
   LINK HERE XXX.)

3. I assert that this _diff_ and commit message was authored as described in
   this commit's metadata. (No assertions about the _snapshot_ are made
   whatsoever, and assertions about parentage are barely sensical at all.
   This meshes with widespread, diff-oriented policies.)

### Grafts and Replacements

Git permits post-hoc replacement of arbitrary objects via both the grafts
system (via an untracked, non-distributed file in `.git`, though some
repositories distribute graft lists for end-users to manually apply) and the
replacements system (via `refs/replace/<SHA1>`, which can optionally be
fetched or pushed). The interaction between these two systems and signature
verification needs to be _very_ closely considered; I've not yet done so.

Cases of note:

* Neither signature nor subject replaced - the "normal" case
* Signature not replaced, subject replaced (by graft, by replacement, by both)
* Signature replaced, subject not replaced
* Both signature and subject replaced

It's tempting to outright disable `git replace` during signing and
verification, but this will have surprising effects when signing a ref-ish
instead of a bare hash. Since this is the _normal_ case, I think this merits
more thought. (I'm also not aware of a way to disable grafts without
modifying `.git`, and having the two replacement mechanisms treated
differently may be dangerous.)

### No Signed Refs

I mentioned early in this draft that Git's existing signing system doesn't
support signing refs themselves; since refs are an important piece of Git's
workflow ecosystem, this may be a major omission. Unfortunately, this
proposal doesn't address that.

## Possible Refinements

* Monotone's certificate system is key+value based, rather than label-based.
  This might be useful; while small pools of related values can be asserted
  using mutually exclusive policy labels (whose mutual exclusion is a matter
  of local interpretation), larger pools of related values rapidly become
  impractical under the proposed system.

  For example, this proposal would be inappropriate for directly asserting
  third-party authorship; the asserted author would have to appear in the
  policy name itself, exposing the user to a potentially very large number of
  similar policy labels.

* Ref signing via a manifest (a tree constellation whose paths are ref names
  and whose blobs sign the refs' values). Consider cribbing DNSSEC here for
  things like lightweight absence assertions, too.

* Describe how this should interact with commit-duplicating and
  commit-rewriting workflows.
