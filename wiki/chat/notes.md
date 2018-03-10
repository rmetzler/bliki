# Notes towards a Chat Service

Now:

* Chat tools divide discussion by "channel"/"room"
* A channel is an undifferentiated sequence of remarks.
* Social dynamics in small channels: don't interrupt the current channel discussion even if you have another discussion to raise that would be within the channel's purpose.
    * Conversations are bimodal: short bursts of generally-interesting remarks, or long chains of interrun responses. Not much middle ground. (Think meme channels vs discussion channels.)
    * Small groups + robots: the robots interrupt things anyways, because they're robots.
* Social dynamics in large channels: it's moving too fast to really track, unless it's the _only_ thing you're doing.

Slack specifically:

* Per-social-circle UI modality makes it awkward to engage with multiple discussions at a time unless they all happen in the same place.
* Universally poor respect for consent.
* Pricing/business model issues:

Instead:

* A channel is a group of distinct discussions, plus a jumping-off point for new discussions.
* A user viewing a channel sees an overview of the ongoing discussions (maintained automatically or semi-automatically) along with lists of their active participants, and any initial remarks that could lead to a new discussion.
* A user can join an ongoing discussion and see the remarks to date, or duck out of it to see the summary again.
* A user can leave an ongoing discussion to indicate that they no longer expect to participate and may not respond to things said.
* Conversations "age out" of channels after they fall silent.
* Aged out conversations are still visible in archives and in the participants' clients, and necroposting brings them back.

* New remarks to the channel appear as "prompts."
* Responding to a prompt creates a conversation.
* Prompts age out (quickly) if not responded to.

![A channel overview. On the left is a list of channels and groups. On the right, dominating the screen, is an area showing two converation previews, with avatar lists and a response button. At the bottom is a callout for John Doe, showing an un-responded-to prompt. Below that is a text field with the legend "Say anything!"](/media/chat/notes/channel-overview.png)

![A conversation overview. On the left is a list of channels and groups. On the right, dominating the screen, is an area showing a single conversation between two participants as a list of chat lines marked by speaker. At the bottom is a callout for John Doe, showing an un-responded-to prompt. Below that is a text field with the legend "Say anything!"](/media/chat/notes/conversation.png)

Why:

* Allow multiple concurrent discussions within the same nominal channel with minimal crosstalk/confusion.
* Insulate conversations from accidental interruptions, while making it easy to intentionally participate.
* Closer model to rooms full of people.
