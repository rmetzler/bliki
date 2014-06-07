# GPG Is Terrible

A discussion at work reminded me that I hadn't looked at the state of the art
for email and communications security in a while. Turns out the options
haven't changed much: S/MIME, which relies on x.509 PKI and is therefore
unusable unless you want to pay for a certificate from someone with lots of
incentives to screw you, or GPG.

S/MIME in the wild is a total non-starter. GPG, on the other hand, is merely
really, _really_ bad.

(You may want to take this with a side of [the other perspective](cool).)

## Body Security And Nothing Else

GPG encrypts and signs email message bodies. That's it, that's all it does
when integrated with email. Email messages contain lots of other useful,
potentially sensitive data: the subject line, for example. GPG still exposes
all of the headers for the world to see, and conversely does nothing to
detect or prevent header tampering by idiot mailers.

(Yes. Signed headers _would_ mean that mailing lists can no longer inject
`[listname]` crud into your messages. Feature, not bug; we should be, and in
many cases already are, storing that in a header of its own, not littering
the subject line. We also need to keep improving mail tooling, to better
handle those headers.)

In return for doing about half of its One Job, GPG demands a _lot_ from its
users.

## The Real Name Policy

The GPG community has a massive “legal names” fixation. [Widespread GPG
documentation](http://cryptnet.net/fdp/crypto/keysigning_party/en/extra/signing_policy.html),
and years of community inertia, stand behind expecting people to put their
legal name in their GPG key, and conversely expecting people to verify the
identity in a GPG key (generally by checking government ID) before signing it.

As the [#nymwars](http://www.jwz.org/blog/2011/08/nym-wars/) folks can tell
you, this policy is harmful and limiting. There are good theoretical reasons
to validate _an_ identity before using its keys to secure messages, but legal
identities can be anywhere from awkward to dangerous to use.

GPG does not _technically_ restrict users from creating autonymous keys, but
the community at large discourages their use unless they can be traced back
to some legal identity. Autonyms keys tend to go unsigned by any other key,
cutting them off from the GPG trust network's validation effect.

## Finding Paul Revere

It turns out autonymity in GPG would be pretty fragile even if GPG's user
community _didn't_ insist on puncturing it at every opportunity, since GPG
irrevocably publishes the social graph of its users to every keyserver they
use. You don't even have to publish it yourself; anyone who has a copy of
your public key can upload a copy for you, revealing to the world the
identities of everyone who knows you well enough to sign your key, and when
they signed it.

A lot of people can be meaningfully identified by that information alone,
even without publishing their personal identity.

## The Web Of Vulnerable CAs

Each GPG user is also a unilateral signing authority. GPG's trust model means
that a compromised key can be used to confer trust onto _any_ other key,
compromising potentially many other users by causing them to trust
illegitimate keys. GPG assumes everyone will be constantly on watch for
unusual signing activity, and perfectly aware of the safety of their own keys
at all times.

## Interoperability

Sending a GPG-signed message to a non-GPG-using normal human being is a great
way to confuse the hell out of them. You have two options:

* In-band “cleartext” signing, which litters the email body with technical
  noise, or
* PGP/MIME, which delivers a meaningless-looking “signature.asc” attachment.

In both cases, the recipient is left with a bunch of information they (a)
can't use and (b) can't hide or remove. It might as well say “virus.dat” for
all the meaning it conveys.

Some of this is not GPG's fault, exactly, but after over a decade, surely
either advocacy or compromise with major mail vendors should have been
possible.

(Accidentally sending an _encrypted_ email to a non-GPG-using recipient is,
thankfully, hard enough to be irrelevant unless someone is actively spoofing
their identity.)

## Webmail Need Not Apply

Well, unless you want to write the message text in an editor, copy and paste
it into GPG, and copy and paste the encrypted blob back out into your
message. (Hope your webmail's online editor doesn't mangle dashes or quotes
for you!)

Apparently Google's [finally fixing that for Chrome
users](https://code.google.com/p/end-to-end/), so that's something.

## Mobile Need Not Apply

<del>Safely distributing GPG keys to mobile applications is more or less
impossible, and integration with mobile mail applications is nonexistant.
Hope you only ever read your mail from a Real Computer!</del>

vollkorn points out that the above is inaccurate. He posted a couuple of
options for GPG on Android, and the state of the art for iOS GPG apps is
apparently better than I was able to find. See [his
comment](#comment-1422227740) for details.
