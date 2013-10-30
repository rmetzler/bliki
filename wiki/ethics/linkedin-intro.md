# LinkedIn Intro is Unethical Software

[LinkedIn Intro](https://intro.linkedin.com) is a mail filtering service
provided by LinkedIn that inserts LinkedIn relationship data into the user's
incoming and outgoing mail. This allows, for example, LinkedIn to decorate
incoming mail with a toolbar linking to the sender's LinkedIn account, and
automatically injects a short "signature" of your LinkedIn profile into
outgoing mail.

These are useful features, and the resulting interaction is quite smooth.
However, the implementation has deep, unsolvable ethical problems.

LinkedIn Intro reconfigures the user's mobile device, replacing their mail
accounts with proxy mail accounts that use LinkedIn's incoming and outgoing
mail servers. All of LinkedIn's user-facing features are implemented using
HTML and JavaScript injected directly into the email message.

## Password Concerns

LinkedIn Intro's proxy mail server must be able to log into the user's real
incoming mail server to retrieve mail, and often must log into the user's real
outgoing mail server to deliver mail with correct SPF or DKIM validation. This
implies that LinkedIn Intro must know the user's email credentials, which it
acquires from their mobile device. Since this is a "use" of a password, not
merely a "validation" of an incoming password, the password must be available
_to LinkedIn_ as plain text. There are two serious problems with this that
are directly LinkedIn's responsibilty, and a third that's indirect but
important. (Some email providers - notably Google - support non-password,
revokable authentication mechanisms for exactly this sort of use. It's not
clear whether LinkedIn Intro uses these safer mechanisms, but it doesn't
materially change my point.)

LinkedIn has a somewhat unhappy security history. In 2012, they had a
[security
breach](http://www.nytimes.com/2012/06/11/technology/linkedin-breach-exposes-light-security-even-at-data-companies.html)
that exposed part of their authentication database to the internet. While they
have very likely tightened up safeguards in response, it's unclear whether
those include a cultural change towards more secure practices. Certainly, it
will take longer than the year that's passed for them to build better trust
from the technical community.

Worse, the breach revealed that LinkedIn was actively disregarding known
problems with password storage for authentication. [Since at least the late
70's](http://cm.bell-labs.com/cm/cs/who/dmr/passwd.ps), the security community
has been broadly aware of weaknesses of unsalted hash-based password
obfuscation. More recently, [it's become
clear](http://www.win.tue.nl/cccc/sha-1-challenge.html) that CPU-optimized
hash algorithms (including MD5 and both SHA-1 and SHA-2) are weak protection
against massively parallel password cracking — cracking that's quite cheap
using modern GPUs. Algorithms like
[bcrypt](http://codahale.com/how-to-safely-store-a-password/) which address
this specific weakness have been available since the late 90's. LinkedIn's
leaked password database was stored using unsalted SHA-1 digests, suggesting
either a lack of research or a lack of understanding of the security
implications of their password system.

Rebuilding trust after this kind of public shaming should have involved a
major, visible shift in the company's culture. There's easy marketing among
techies — a major portion of LinkedIn's audience, even now — to be done by
showing how on the ball you can be about protecting their data; none of this
marketing has appeared. The impact of raising the priority of security issues
throughout product development should be visible from the outside, as risky
features get pushed aside to address more fundamental security issues; no such
shift in priorities has been visible. It is reasonable, observing LinkedIn's
behaviour in the last year, to conclude that LinkedIn, as a company, still
treats data security as an easy problem to be solved with as little effort as
possible. This is not a good basis on which to ask users to hand over their
email passwords.

While the security community has been making real efforts to educate users to
use a unique password for each service they use, the sad reality is that most
users still use the same password for everything. As LinkedIn Intro must
necessarily store _plain text_ passwords, it will be a very attractive target
for future break-ins, for employee malfeasance, and for United States court
orders.

## What Gets Seen

LinkedIn Intro is not selective. Every email that passes through an
Intro-enabled email account is visible, entirely, to LinkedIn. The fact that
the email occurred is fodder for their recommendation engine and for any other
analysis they care to run. The contents may be retained indefinitely, outside
of either the sender's or the recipients' control. LinkedIn is in a position
to claim that Intro users have given it _permission_ to be intrusive into
their email in this way.

Very few people use a dedicated email account for "corporate networking" and
recruiting activities. A CEO (LinkedIn's own example) recieves mail pertaining
to many sensitive aspects of a corporation's running: lawsuit notices, gossip
among the exec team, planning emails discussing the future of the company,
financials, email related to external partnerships at the C*O level, and many,
many other things. LinkedIn's real userbase, recruiters and work-seeking
people, often use the same email account for LinkedIn and for unrelated
private activities. LinkedIn _has no business_ reading these emails or even
knowing of their existence, but Intro provides no way to restrict what
LinkedIn sees.

Users in heavily-regulated industries, such as health care or finance, may be
exposing their whole organization to government interventions by using Intro,
as LinkedIn is not known to be HIPAA, SOX, or PCI compliant.

The resulting "who mailed what to whom" database is hugely valuable. I expect
LinkedIn to be banking on this; such a corpus of conversational data would
greatly help them develop new features targetting specific groups of users,
and could improve the overall effectiveness of their recommendation engine.
However, it's also valuable to others; as above, this information would be a
gold mine for marketers, a target for break-ins, and, worryingly, _immensely_
useful to the United States' intelligence apparatus (who can obtain court
orders preventing LinkedIn from discussing their requests, to boot).

(LinkedIn's recommendation engine also has issues; it's notorious for
[recommending people to their own
ex-partners](http://community.linkedin.com/questions/31650/linkedin-sent-an-ex-girlfriend-a-request-to-someon.html)
and to people actively suing one another. Giving it more data to work with
makes this more likely, especially when the data is largely unrelated to
professional concerns..)

LinkedIn Intro's injected HTML is also suspect by default. Tracking email open
rates is standard practice for email marketing, but Intro allows _LinkedIn_ to
track the open rate of emails _you send_ and of emails _you recieve_,
regardless of whether those emails pertain to LinkedIn's primary business or
not.

## User Education

All of the risks outlined above are manageable. With proper information, the
end user can make an informed decision as to whether

* to ignore Intro at all, or
* to use Intro with a dedicated "LinkedIn Only" email account, or
* to use Intro with everything

LinkedIn's own marketing materials outline _absolutely none_ of these risks.
They're designed, as most app landing materials are, to make the path to
downloading and configuring Intro as smooth and unthreatening as possible: the
option to install the application is presented before the page describes what
the app _does_, and it never describes how the app _works_ — that information
is never stated outright, not even in Intro's own
[FAQ](https://intro.linkedin.com/micro/faq). Witholding the risks from users
vastly increases the chances of a user making a decision they aren't
comfortable with, or that increases their own risk of social or legal problems
down the road.

## LinkedIn's Response

Shortly after Intro's first round of public mockery, a LinkedIn employee
[posted a
resonse](http://blog.linkedin.com/2013/10/26/the-facts-about-linkedin-intro/)
to some of the security concerns. The post is interesting, and I recommend you
read it.

The key point about the response is that it underscores how secure Intro is
_for LinkedIn_. It does absolutely nothign to discuss how LinkedIn is curating
its users' security needs. In particular:

> We isolated Intro in a separate network segment and implemented a
> tight security perimeter across trust boundaries.

A breach in LinkedIn proper may not imply a breach in LinkedIn Intro, and vice
versa, but there must be at least some data passing back and forth for Intro
to operate. The nature and structure of the security mechanisms that permit
the "right" kind of data are not elaborated on; it's impossible to decide how
well they actually insulate Intro from LinkedIn. Furthermore, a breach in
LinkedIn Intro is still incredibly damaging even if it doesn't span LinkedIn
itself.

> Our internal team of experienced testers also penetration-tested the
> final implementation, and we worked closely with the Intro team to
> make sure identified vulnerabilities were addressed.

This doesn't address the serious concerns with LinkedIn Intro's _intended_
use; it also doesn't do much to help users understand how thorough the testing
was or to understand who vetted the results.

## The Bottom Line

_If_ LinkedIn Intro works as built, and _if_ their security safeguards are put
into place, then Intro exposes its users to much greater risk of password
compromise and helps them expose themselves to surveillence, both government
and private. If either of those conditions does not hold, it's worse.

The software industry is young, and immature, and wealthy. There is no ethics
body to complain to; had the developers of Intro said "no", they would very
likely have been replaced by another round of developers who would help
LinkedIn violate their users' privacy. That does not excuse LinkedIn; their
product is vile, and must not be tolerated in the market.
