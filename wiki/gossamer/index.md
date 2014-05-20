# Gossamer: A Decentralized Status-Sharing Network

Twitter's pretty great. The short format encourages brief, pithy remarks, and
the default assumption of visibility makes it super easy to pitch in on a
conversation, or to find new people to listen to. Unfortunately, Twitter is a
centralized system: one Bay-area company in the United States controls and
mediates _all_ Twitter interactions.

From all appearances, Twitter, Inc. is relatively benign, as social media
corporations go. There are few reports of censorship, and while their
response to abuse of the Twitter network has not been consistently awesome,
they can be made to listen. However, there exists the capacity for Twitter,
Inc. to subvert the entire Twitter system, either voluntarily or at the
behest of governments around the world.

(Just ask Turkish people. Or the participants in the Arab Spring.)

Gossamer is a Twitter-alike system, designed from the ground up to have no
central authority. It resists censorship, enables individual participants to
control their own data, and allows anyone at all to integrate new software
into the Gossamer network.

Gossamer does not exist, but if it did, the following notes describe what it
might look like, and the factors to consider when implementing Gossamer as
software.

## Design Goals

* Users must be in control of their own privacy and identity at all times.
  (This is a major failing with Diaspora, which limits access to personal
  ownership of data by being hard to run.)

* Users must be able to communicate without the consent or support of an
  intermediate authority. Short of being completely offline, Gossamer should
  be resilient to infrastructural damage.

* Any functional communication system _will_ be used for illicit purposes.
  This is an unavoidable consequence of being usable for legitimate purposes
  without a central authority. Rather than revealing illicit conversations,
  Gossamer should do what it can to preserve the anonymity and privacy of
  legitimate ones.

* All nodes are as equal as possible. The node _I_ use is not more
  authoritative for messages from me than any other node. You can hear my
  words from anyone who has heard my words, and I can hear yours from anyone
  who has heard your words, so long as some variety of authenticity and
  privacy are maintained.

* If an identity's secrets are removed, a node should contain no data that
  correlates the owner with his or her Gossamer identities. Relaying and
  authoring must be as indistinguishable as possible, to limit the utility of
  traffic analysis.

## Public and Private Information

Every piece of data Gossamer uses, either internally or to communicate with
other ndoes, is classified as either _public_ or "private". Public
information can be communicated to other nodes, and is assumed to be safe if
recovered out of band. Private information includes anything which may be
used to associate a Gossamer identity with the person who controls it, except
as noted below.

Gossamer must ensure users understand what information that they provide will
be made public, and what will be kept private, so that they can better decide
what, if anything, to share and so that they can better make decisions about
their own safety and comfort against abusive parties.

Internally, Gossamer _always_ stores private information encrypted, and
_never_ transmits it to another node. Gossamer _must_ provide a tool to
safely obliterate private data.

### Public Information

Details on the role of each piece of information are covered below.

* Public status updates, obviously. Gossamer exists to permit users to easily
  share short messages with one another.

* The opaque form of a user's incoming and outgoing private messages.

* The users' identities' public keys. (But not their relationship to one
  another.)

* Any information the user places in their profile. (This implies that
  profiles _must not_ be auto-populated from, for example, the user's address
  book.)

* The set of identities verified by the user's identity.

Any other information Gossamer retains _must_ be private.

## Republishing

Gossamer is built on the assumption that every participant is willing to act
as a relay for every other participant. This is a complicated assumption at
the human layer.

Inevitably, someone will use the Gossamer network to communicate something
morally repugnant or deeply illegal: the Silk Road guy, for example, got done
for trying to contract someone to commit murder. Every Gossamer node is
complicit in delivering those messages to the rest of the network, whether
they're in the clear (status updates) or not (private messages). It's unclear
how this interacts with the various legal frameworks, moral codes, and other
social constructs throughout the world, and it's ethically troubling to put
users in that position by default.

The strong alternative, that each node only relay content with the
controlling user's explicit and ongoing consent, is also troubling: it limits
the Gossamer network's ability to deliver messages _at all_, and exposes
information about which identities each node's owner considers interesting
and publishable.

I don't have an obvious resolution to this. Gossamer's underlying protocol
relies on randomly-selected nodes being more likely to propagate a message
than to ignore it, because this helps make Gossamer resilient to hostile
users, nosy intelligence agencies, and others who believe communication must
be restrictable. On the other hand, I'd like not to put a user in Thaiwan at
risk of legal or social reprisals because a total stranger in Canada decided
to post something vile.

(This is one of the reasons I haven't _built_ the damn thing yet. Besides
being A Lot Of Code, there's no way to shut off Gossamer once more than one
node exists, and I want to be sure I've thought through what I'm doing before
creating a prototype.)

## Identity in the Gossamer Network

Every Gossamer _message_ carries with it an _identity_. Gossamer identities
are backed by public-key cryptography. However, unlike traditional public key
systems such as GPG, Gossamer identities provide _continuity_, rather than
_authenticity_: two Gossamer messages signed by the same key are from the
same identity, but there is no inherent guarantee that that identity is
legitimate.

Gossamer maintains relationships between identities to allow users to
_verify_ the identities of one another, and to publish attestations of that
to other Gossamer nodes. From this, Gossamer can recover much of GPG's "web
of trust".

**TODO**: revocation of identities, revocation of verifications. Both are
important; novice users are likely to verify people poorly, and there should
be a recovery path less drastic than GPG's "you swore it, you're stuck with
it" model.

Gossamer encourages users to create additional identities as needed to, for
example, support the separation of work and home conversations, or to provide
anonymity when discussing reputationally-hazardous topics. Identities are not
correlated by the Gossamer codebase.

Each identity can optionally include a _profile_: a block of data describing
the person behind the identity. The contents of a profile are chosen by the
person holding the private key for an identity, and the profile is attached
to every new message created with the corresponding identity. A user can
update their profile at will; potentially, every message can be sent with a
distinct profile. Gossamer software treats the profile it's seen with the
highest timestamp as authoritative, retroactively applying it to old messages.

### Multiple Devices and Key Security

A Gossamer identity is entirely contained in its private key. An identity's
key must be stored safely, either using the host operating system's key
management facilities or using a carefully-designed key store. Keys must not
hit long-term storage unprotected; this may involve careful integration with
the underlying OS's memory management facilities to avoid, eg., placing
identities in swap. This is _necessary_ to protect users from having their
identities recovered against their will via, for example, hard drive
forensics.

Gossamer allows keys to be exported into password-encrypted archive files,
which can be loaded into other Gossamer applications to allow them to share
the same identity.

**GOSSAMER MUST TREAT THESE FILES WITH EXTREME CARE, BECAUSE USERS PROBABLY
WON'T**. Identity keys protect the user's Gossamer identity, but they _also_
protect the user's private messages (see below) and other potentially
identifying data. The export format must be designed to be as resilient as
possible, and Gossamer's software must take care to ensure that "used"
identity files are _automatically_ destroyed safely wherever possible and to
discourage users from following practices that weaken their own safety
unknowingly.

Exported identity files are intrinsically vulnerable to offline brute-force
attacks; once obtained, an attacker can try any of the worryingly common
passwords at will, and can easily validate a password by using the recovered
keys to regenerate some known fact about the original, such as a verification
or a message signature. This implies that exported identities _must_ use a
key derivation system which has a high computational cost and which is
believed to be resilient to, for example, GPU-accelerated cracking.

Secure deletion is a Hard Problem; where possible, Gossamer must use
operating system-provided facilities for securely destroying files.

## Status Messages

Status messages are messages visible to any interested Gossamer users. These
are the primary purpose of Gossamer. Each contains up to 140 Unicode
characters, a markup section allowing Gossamer to attach URLs and metadata
(including Gossamer locators) to the text, and an attachments section
carrying arbitrary MIME blobs of limited total size.

All three sections are canonicalized (**TODO**: how?) and signed by the
publishing identity's private key. The public key, the identity's most recent
profile, and the signed status message are combined into a single Gossamer
message and injected into the user's Gossamer node exactly as if it had
arrived from another node.

Each Gossamer node maintains a _follow list_ of identities whose messages the
user is interested in seeing. When Gossamer receives a novel status message
during a gossip exchange, it displays it to the user if and only if its
identity is on the node's follow list. Otherwise, the message is not
displayed, but will be shared onwards with other nodes. In this way, every
Gossamer node acts as a relay for every other Gossamer node.

If Gossamer receives a message signed by an identity it has seen attestations
for, it attaches those attestations to the message before delivering them
onwards. In this way, users' verifications of one another's identity spread
through the network organically.

## Private Messages

Gossamer can optionally encrypt messages, allowing users to send one another
private messages. These messages are carried over the Gossamer network as
normal, but only nodes holding the appropriate identity key can decrypt them
and display them to the user. (At any given time, most Gossamer nodes hold
many private messages they cannot decrypt.)

Private messages _do not_ carry the author's identity or full profile in the
clear. The author's bare identity is included in the encrypted part of the
message, to allow the intended recipient to identify the sender.

**TODO**: sign-then-encrypt, or encrypt-then-sign? If sign-then-encrypt, are
private messages exempted from the "drop broken messages" rule above?

## Following Users

Each Gossamer node maintains a database of _followed_ identities. (This may
or may not include the owner's own identity.) Any message stored in the node
published by an identity in this database will be shown to the user in a
timeline-esque view.

Gossamer's follow list is _purely local_, and is not shared between nodes
even if they have identities in common. The follow list is additionally
stored encrypted using the node's identities (any one identity is sufficient
to recover the list), to ensure that the follow list is not easily available
to others without the node owner's permission.

Exercises such as [Finding Paul Revere](http://kieranhealy.org/blog/archives/2013/06/09/using-metadata-to-find-paul-revere/)
have shown that the collection of graph edges showing who communicates with
whom can often be sufficient to map identities into people. Gossamer attempts
to restrict access to this data, believing it is not the network's place to
know who follows who.

## Verified Identities

Gossamer allows identities to sign one anothers' public keys. These
signatures form _verifications_. Gossamer considers an identity _verified_ if
any of the following hold:

* Gossamer has access to the identity key for the identity itself.

* Gossamer has access to the identity key for at least one of the identity's
  verifications.

* The identity is signed by at least three (todo: or however many, I didn't
  do the arithmetic yet) verified identities.

Verified identities are marked in the user interface to make it obvious to
the user whether a message is from a known friend or from an unknown identity.

Gossamer allows users to sign new verifications for any identity they have
seen. These verifications are initially stored locally, but will be published
as messages transit the node as described below. Verification is a _public_
fact: everyone can see which identities have verified which other identities.
This is a potentially very powerful tool for reassociating identities with
real-world people; Gossamer _must_ make this clear to users.

(I'm pretty sure you could find me, personally, just by watching whose
identities I verify.)

Each Gossamer node maintains a database of every verification it has ever
seen or generated. If the node receives a message from an identity that
appears in the verification database, and if the message is under some total
size, Gossamer appends verifications from its database to the message before
reinjecting it into the network. This allows verifications to propagate
through

## Blocking Users

Any social network will attract hostile users who wish to disrupt the network
or abuse its participants. Users _must_ be able to filter out these users,
and must not provide too much feedback to blocked users that could otherwise
be used to circumvent blocks.

Each Gossamer node maintains a database of blocked identities. Any message
from an identity in this database, or from an identity that is verified by
three or more identities in this database, will automatically be filtered out
from display. (Additionally, transitively-blocked users will automatically be
added to the block database. Blocking is contagious.) (**TODO**: should
Gossamer _drop_ blocked messages? How does that interact with the inevitable
"shared blocklist" systems that arise in any social network?)

As with the follow list, the block database is encrypted using the node's
identities.

Gossamer encourages users to create new identities as often as they see fit
and attempts to separate identities from one another as much as possible.
This is fundamentally incompatible with strong blocking. It will _always_ be
possible for a newly-created identity to deliver at least one message before
being blocked. _This is a major design problem_; advice encouraged.

## Gossamer Network Primitives

The Gossamer network is built around a gossip protocol, wherein _nodes_
connect to one another periodically to exchange _messages_ with one another.
Connections occur over the existing IP internet infrastructure, traversing
NAT networks where possible to ensure that users on residential and corporate
networks can still participate.

Gossamer bootstraps its network using a number of paths:

* Gossamer nodes in the same broadcast domain discover one another using UDP
  broadcasts as well as Bonjour/mDNS.

* Gossamer can generate _locator_ strings, which can be shared "out of band"
  via email, SMS messages, Twitter, graffiti, etc.

* Gossamer nodes share knowledge of nodes whenever they exchange messages, to
  allow the Gossamer network to recover from lost nodes and to permit nodes
  to remain on the network as "known" nodes are lost to outages and entropy.

### Locators

A Gossamer _locator_ is a URL in the `g` scheme, carrying an encoding of one
or more network addresses as well as an encoding of one or more identities
(see below). Gossamer's software attempts to determine an appropriate
identifier for any identities it holds based on the host computer's network
configuration, taking into account issues like NAT traversal wherever
possible.

**TODO**: Gossamer and uPNP, what do locators _look_ like?

When presented with an identifier, Gossamer offers to _follow_ the identities
it contains, and uses the _nodes_ whose addresses it contains to connect to
the Gossamer network. This allows new clients to bootstrap into Gossamer, and
provides an easy way for users to exchange Gossamer identities to connect to
one another later.

(Clever readers will note that the address list is actually independent of
the identity list.)

### Gossip

Each Gossamer node maintains a pair of "freshness" databases, associating
some information with a freshness score (expressed as an integer). One
freshness database holds the addresses of known Gossamer nodes, and another
holds Gossamer messages.

Whenever two Gossamer nodes interact, each sends the other a Gossamer node
from its current node database, and a message from its message database. When
selecting an item to send for either category, Gossamer uses a random
selection that weights towards items with a higher "freshness" score.
(**TODO**: how?)

When sending a fact, if the receiving node already knows the fact, both nodes
decrement that fact's freshness by one. If the receiving node _does not_
already know the fact, the sending node leaves its freshness unaltered, and
the receiving node sets its freshness to the freshest possible value. This
system encourages nodes to exchange "fresh" facts, then cease exchanging them
as the network becomes aware of them.

During each exchange, Gossamer nodes send each other one Gossamer node
address, and one Gossamer message. Both nodes adjust their freshness
databases, as above.

If fact exchange fails while communicating with a Gossamer node, both nodes
decrement their peer's freshness. Unreliable nodes can continue to initiate
connections to other nodes, but will rarely be contacted by other Gossamer
nodes.

**TODO**: How do we avoid DDOSing brand-new gossamer nodes with the full
might of Gossamer's network?

**TODO**: Can we reuse Bittorrent's DHT system (BEP-5) to avoid having every
node know the full network topology?

**TODO**: Are node-to-node exchanges encrypted? If so, why and how?

### Authenticity

Gossamer node addresses are not authenticated. Gossamer relies on freshness
to avoid delivering excess traffic to systems not participating in the
Gossamer network. (**TODO**: this is a shit system for avoiding DDOS, though.)

Gossamer messages _are_ partially authenticated: each carries with it a
public key, and a signature. If the signature cannot be verified with the
included public key, it _must_ be discarded immediately and it _must not_ be
propagated to other nodes. The node delivering the message _may_ also be
penalized by having its freshness reduced in the receiving node's database.

### Gossip Triggers

Gossamer triggers a new Gossip exchange under the following circumstances:

* 15 seconds, plus a random jitter between zero and 15 more seconds, elapse
  since the last exchange attempt.

* Gossamer completes an exchange wherein it learned a new fact from another
  node.

* A user injects a fact into Gossamer directly.

Gossamer exchanges that fail, or that deliver only already-known facts, do
not trigger further exchanges immediately.

**TODO**: how do we prevent Gossamer from attempting to start an unbounded
number of exchanges at the same time?

### Size

Gossamer must not exhaust the user's disk. Gossamer discards _extremely_
un-fresh messages, attempting to keep the on-disk size of the message
database to under 10% of the total local storage, or under a
user-configurable threshold.

Gossamer rejects over-large messages. Public messages carry with them the
author's profile and a potentially large collection of verifications.
Messages over some size (**TODO** what size?) are discarded on receipt
without being stored, and the message exchange is considered to have failed.
