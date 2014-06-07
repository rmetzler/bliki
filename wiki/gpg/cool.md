# GPG Is Pretty Cool

The GPG software suite is a pretty elegant cryptosystem. It provides:

* A standard, well-maintained set of tools for creating and storing keys, and
  associating them with identities

* A suite of reliable tools for encrypting, signing, decrypting, and
  verifying data that can be easily assembled into any combination of
  integrity checks, authenticity checks, and privacy management

* A key distribution network that does not rely on hierarchal authority and
  that can be bootstrapped from scratch quickly and easily

While GPG [sucks in a number of important ways](terrible), it's also the best
tool we have right now for restoring privacy to private correspondance over
the internet.

## Code Signing

Pretty much every Linux distribution relies on GPG for code signing. Rather
than using GPG's web-of-trust model for key distribution, however, code
signing with GPG usually creates a hierarchal PKI so that the root keys can
be shipped with the operating system.

This works shockingly well, and support for GPG is extremely well integrated
into common package management systems such as apt and yum.

## Source Control

Which is basically code signing, admittedly, but even Git's support for GPG
is basically great. Tools like Fossil embed it even deeper, and work quite
well.

## Email

GPG's integration with email is surprisingly clever, follows a number of
long-standing best practices for extending email, and does a _very_ good job
of providing some guarantees that make sense in a not-terribly-long-ago view
of email as a communications medium. In particular, if

* who you talk to is not a secret, and
* what, broadly, you are talking about is not a secret, but
* the specifics of the discussion _are_ a secret, and
* all participants are using GPG on their own mailers

then GPG works brilliantly and modern GPG integration is very effective.

These assumptions pretty accurately reflect the majority of email use up
through the late 90s and early 2000s: technical or personal correspondence
between known acquaintences.

The internet has moved on from email for casual correspondence, but that
doesn't invalidate the elegance of GPG's integration for GPG users.

## Distributed Verification

Even though GPG's trust model has some serious privacy costs and concerns, it
works as a great proof of concept for CA-free identity management. That's
huge: centralized CAs have even more onerous costs and worse risks than GPG's
trust network, while offering less transparency to help offset those costs.

Others have written some pretty interesting things on how to improve GPG's
trust model and make it less succeptible to errors or key leaks by
small-to-middling numbers of participants. [This
post](https://lists.torproject.org/pipermail/tor-talk/2013-September/030235.html)
to tor-talk last year is probably the most complete.
