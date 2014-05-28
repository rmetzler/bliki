# Design Mistakes

## Is Gossamer Up?

[@megtastique](https://twitter.com/megtastique) points out that two factors
doom the whole design:

1. There's no way to remove content from Gossamer once it's published, and

2. Gossamer can anonymously share images.

Combined, these make Gossamer the _perfect_ vehicle for revenge porn and
other gendered, sexually-loaded network abuse.

This alone is enough to doom the design, as written: even restricting the
size of messages to the single kilobyte range still makes it trivial to
irrevocably disseminate _links_ to similar content.

## Protected Feeds? Who Needs Those?

Gossamer's design does not carry forward an important Twitter feature: the
protected feed. In brief, protected feeds allow people to be choosy about who
reads their status updates, without necessarily having to pick and choose who
gets to read them on a message by message basis.

This is an important privacy control for people who wish to engage with
people they know without necessarily disclosing their whereabouts and
activities to the world at large. In particular, it's important to vulnerable
people because it allows them to create their own safe spaces.

Protected feeds are not mere technology, either. Protected feeds carry with
them social expectations: Twitter clients often either refuse to copy text
from a protected feed, or present a warning when the user tries to copy text,
which acts as a very cheap and, apparently, quite effective brake on the
casual re-sharing that Twitter encourages for public feeds.

## DDOS As A Service

Gossamer's network protocol converges towards a total graph, where every node
knows how to connect to every other node, and new information (new posts)
rapidly push out to every single node.

If you've ever been privy to the Twitter “firehose” feed, you'll understand
why this is a drastic mistake. Even a moderately successful social network
sees on the order of millions of messages a day. Delivering _all_ of this
directly to _every_ node _all_ of the time would rapidly drown users in
bandwidth charges and render their internet connections completely unusable.

Gossamer's design also has no concept of “quiet” periods: every fifteen to
thirty seconds, rain or shine, every node is supposed to wake up and exchange
data with some other node, regardless of how long it's been since either node
in the exchange has seen new data. This very effectively ensures that
Gossamer will continue to flood nodes with traffic at all times; the only way
to halt the flood is to shut off the Gossamer client.

## Passive Nodes Matter

It's impractical to run an inbound data service on a mobile device. Mobile
devices are, by and large, not addressable or reachable by the internet at
large.

Mobile devices also provide a huge proportion of Twitter's content: the
ability to rapidly post photos, location tags, and short text while away from
desks, laptops, and formal internet connections is a huge boon for ad-hoc
social organization. You can invite someone to the pub from your phone, from
in front of the pub.

(This interacts ... poorly with the DDOS point, above.)

## Traffic Analysis

When a user enters a new status update or sends a new private message, their
Gossamer node immediately forwards it to at least one other node to inject it
into the network. This makes unencrypted Gossamer relatively vulnerable to
traffic analysis for correlating Gossamer identities with human beings.

Someone at a network “pinch point” -- an ISP, or a coffee shop wifi router --
can monitor Gossamer traffic entering and exiting nodes on their network and
easily identify which nodes originated which messages, and thus which nodes
have access to which identities. This seriously compromises the effectiveness
of Gossamer's decentralized, self-certifying identities.
