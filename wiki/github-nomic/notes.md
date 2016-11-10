# Notes towards initial rules for a Github Nomic

This document is not part of the rules of a Nomic, and is present solely as a guide to the design of [this initial ruleset](rules), for play on Github.
It should be removed before the game starts, and at no time should it be consulted to guide gameplay directly.

Peter Suber's [Nomic](http://legacy.earlham.edu/~peters/writing/nomic.htm) is a game of rule-making for one or more players.
For details on the rationale behind the game and the reasons the game might be interesting, see Suber's own description.

# Changes from Suber's rules

## Format

I've marked up Suber's rules into Markdown, one of Github's “native” text markup formats.
This highly-structured format produces quite readable results when viewed through the Github website, and allows useful things like HTML links that point to specific rules.

I've also made some diff-friendliness choices around the structure of those Markdown documents.
For want of a better idea, the source documents are line-broken with one sentence per line, so that diffs naturally span whole sentences rather than arbitrarily-wrapped text (or unwrapped text).
Since Github automatically recombines sequences of non-blank lines into a single HTML paragraph, the rendering on the web site is still quite readable.

I have not codified this format in the rules themselves.

## Asynchrony

In its original form, Nomic is appropriate for face-to-face play.
The rules assume that it is practical for the players to identify one another using out-of-game context, and that it is practical for the players to take turns.
Each player is expected to wait indefinitely (or, more likely, to apply non-game social pressure) if the preceding player takes inordinately long to complete their turn.
Similarly, Judgement interrupts the flow of game play and brings turns to a stop.

This Nomic is to be played on Github, and the players are _not_ likely to be present simultaneously, or to be willing to wait indefinitely.

It's possible for Suber's original Nomic rules to be amended, following themselves, into a form suitable for asynchronous play.
This has happened several times: for examples, see [Agora](http://agoranomic.org/) and [BlogNomic](http://blognomic.com/), though there are a multitude of others.
However, this process of amendment takes _time_, and, starting from Suber's initial rules, would require a period of one-turn-at-a-time rule-changes before the game could be played more naturally in the Github format.
This period is not very interesting, and is incredibly demanding of the initial players' attention spans.

In the interests of preserving the players' time, I have modified Suber's initial ruleset to replace sequential play with a simple asynchronous model of play. In summary:

* Every player can begin a turn at any time, even during another player's (or players') turn, so long as they aren't already taking a turn.
* Actions can be resolved in any order, depending on which proposals players choose to vote on, and in what order.
* The initial rules allow for players to end their turns without gathering every vote, once gameplay has proceeded far enough for non-unanimous votes to be possible.

I have attempted to leave the rules as close to Suber's original rules as possible otherwise while implementing this change to the initial ruleset.
I have faith that the process of playing Nomic will correct any deficiencies, or, failing that, will clearly identify where these changes break the game entirely.

I have, as far as I am able, emulated Suber's preference for succinctness over thoroughness, and resisted the urge to fix or clarify rules even where defects seem obvious to me.
In spite of my temptation to remove it, I have even left the notion of “winning” intact.

## Rule-numbering

The intent of this Nomic is to explore the suitability of Github's suite of tools for proposing, reviewing, and accepting changes to a corpus of text are suitable for self-governed rulemaking processes, as modelled by Nomic.
Note that this is a test of Github, not of Git: it is appropriate and intended that the players rely on non-Git elements of Github's workflow (issues, wiki pages, Github Pages, and so on), and similarly it is appropriate and intended that the authentic copy of the game in play is the Github project hosting it, not the Git repo the project contains, and certainly not forks of the project or other clones of the repository.

To support this intention, I have re-labelled the initial rules with ngative numbers, rather than digits, so that proposals can be numbered starting from 1 without colliding with existing rules, and so that they can be numbered by their Pull Requests and Github issue numbers.
(A previous version of these rules used Roman numerals for the initial rules.
However, correctly accounting for the priority of new rules over initial rules, following Suber, required more changes than I was comfortable making to Suber's ruleset.)
I have made it explicit in these initial rules that Github, not the players, assigns numbers to proposals.
This is the only rule which mentions Github by name.
I have not explicitly specified that the proposals should be implemented through pull requests; this is an intentional opportunity for player creativity.

## Projects & Ideas

A small personal collection of other ideas to explore:

### Repeal or replace the victory criteria entirely

“Winning” is not an objective I'm personally interested in, and Suber's race to 200 points by popularity of proposal is structurally quite dull.
If the game is to have a victory condition, it should be built from the ground up to meet the players' motivations, rather than being retrofitted onto the points-based system.

### Codify the use of Git commits, rather than prose, for rules-changes

This is unstated in this ruleset, despite being part of my intention for playing.
So is the relationship between proposals and the Git repository underpinning the Github project hosting the game.

### Clarify the immigration and exit procedures

The question of who the players _are_, or how one becomes a player, is left intentionally vague.
In Suber's original rules, it appears that the players are those who are engaged in playing the game: tautological on paper, but inherently obvious by simple observation of the playing-space.

On Github, the answer to this question may not be so simple.
A public repository is _visible_ to anyone with an internet connection, and will accept _proposed_ pull requests (and issue reports) equally freely.
This suggests that either everyone is, inherently, a player, or that player-ness is somehow a function of engaging with the game.
I leave it to the players to resolve this situation to their own satisfaction, but my suggestion is to track player-ness using repository collaborators or organization member accounts.

### Figure out how to regulate the use of Github features

Nomic, as written, largely revolves around sequential proposals.
That's fine as far as it goes, but Github has a very wide array of project management features - and that set of features changes over time, outside the control of the players, as Github roll out improvements (and, sometimes, break things).

Features of probable interest:

* The `gh-pages` branch and associated web site.
* Issue and pull request tagging and approval settings.
* Third-party integrations.
* Whether to store non-rule state, as such arises, in the repository, or in the wiki, or elsewhere.
* Pull request reactions and approvals.
* The mutability of most Github features.

### Expand the rules-change process to permit a single proposal to amend many rules

This is a standard rules patch, as Suber's initial rule-set is (I believe intentionally) very restrictive.

This may turn out to be less relevant on Github, if players are allowed to submit turns in rapid succession with themselves.

### Transition from immediate amendment to a system of sessions

Why not? Parliamentary procedure is fun, right?

In an asynchronous environment, the discrete phases of a session system (where proposals are gathered, then debated, then voted upon, then enacted as a unit) might be a better fit for the Github mode of play.

### Evaluate other models of proposal vetting besides majority vote

Github open source projects regularly have a small core team of maintainers supporting a larger group of users.
Is it possible to mirror this structure in Nomic?
Is it wise to do so?

I suspect this is only possible with an inordinately large number of players, but Github could, at least in principle, support that number of players.

Note that this is a fairly standard Nomic passtime.
