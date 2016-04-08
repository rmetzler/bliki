# Narrative in MUDs

Design notes towards narrative conventions.

## What?

MUDs are engines of narration. The human interface to one is, to a first approximation, literary: everything that happens is realized as words, which are read, and the user's actions on the system are performed through writing.

MUDs are a distinct subform of interactive fiction. In classic IF, the IF engine produces a single narrative, with which a single player interacts (usually synchronously - each narration by the engine leads to a single reply from the player, which then leads to further narration). MUDs, by contrast, produce _parallel_ narratives. Each player receives their own, distinct narrative, which depicts events happening in a shared fictional space. Furthermore, these narratives conventionally occur asynchronously, with replies from each player injecting further text into many players's narratives.

For example, the following three narratives depict the same sequence of events, as presented to three distinct players.

First, Alice's perspective:

> You open the door and enter the house.
>
> -----
>
> **Living Room**
>
> You're in the sparsely-furnished living room of an insipidly-generic student apartment. A TV sits on a bench, opposite a cheap and decrepit sofa. The front door opens to the south; beside it is an indifferent pile of salt-stained boots.
>
> Bob is here. cherise is here, seated on the sofa.
>
> -----
>
> You say, "Hello."
>
> cherise says, "Called it."
>
> Bob walks out through the front door.
>
> You ask, "What's his problem?"

Then, Bob's:

> cherise sighs. "I'm sure she'll be here soon."
>
> Alice walks in through the front door.
>
> Alice says, "Hello."
>
> cherise says, "Called it."
>
> You open the front door and walk out.
>
> -----
>
> **Hallway**
>
> You're standing in a grungy apartment hallway. It smells faintly of mildew and old cigarettes. An apartment's front door opens to the north.
>
> -----

Finally, cherise's perspective:

> You sigh. "I'm sure she'll be here soon."
>
> Alice walks in through the front door.
>
> Alice says, "Hello."
>
> You say, "Called it."
>
> Bob walks out through the front door.
>
> Alice asks, "What's his problem?"

I've intentionally used widespread MUD narrative conventions to illustrate some points.

In daily life, this sort of parallel experience of overlapping events and partial perspectives is unremarkable. In interactive fiction, it's nearly unheard-of, outside of MUDs, and in the context of literary fiction, it raises some complex questions:

* Who is Alice's narrator? Or cherise's?
* Just how many narrators _are_ there? Do the participants share a common narrator, or are they each an independently narrated story?
* The three perspectives shown here are the limited perspectives of each participant in the scene. Is there also an omniscient perspective? If so, does it have a coherent narrative? Is there anything about the scene that one narrator might omit, where another would include it?
* Why does the narrator present those specific elements of the _places_ each perspective visits, and how do those choices related to choices of perspective, tense, and person? Do Alice and cherise see the living room the same way? Should they?
* Why the second person?
* Why the present tense?

## Some Bad History

MUD narrative conventions largely arise from technical choices themselves motivated by the context MUDs arose in. MUDs originated as the product of a literarily-unsophisticated technical community: early MUDs were engines for sharing swords-and-sorcery adventures with friends, little more than multiplayer-enabled versions of Zork or Colossal Cave (themselves somewhat limited renditions of a quest story).

Even later "talker" MUDs, designed specifically around social interaction rather than around adventure, and "VR" MUDs, designed around simulating elements of a shared space through text, derive a lot of narrative conventions from those ancestors.

This ancestry has some consequences.

The narrators of Zork and Colossal Cave speak in the second person; the protagonist character is a faceless, ageless, genderless proxy for the player, and this allows the narrator to conflate the two to effectively engage the player with the fictional world. Early MUDs ape this convention, but MUD characters _require_ names, since it's impractical to describe more than two characters in a narrative without some way to identify each character. The second person convention persists in those systems, even though the player and the character could (and often did) have divergent identities.

Not every game uses the second person effectively. Games with a freeform 'pose' affordance allow players to inject player-constructed prose into the narrative to reflect actions not pre-envisioned by the game's authors. This almost universally breaks from the second person; a single line of prose provided by the player is not usually corrected for personal pronouns by the game before being delivered back through player narratives. If cherise runs the command

> `pose waves at Alice.`

most MUDs will generate the prose

> cherise waves at Alice.

in all three of Alice, Bob, and cherise's narratives, even though cherise's other actions in cherise's narrative are presented using the pronoun "You."

This can be particularly jarring when some poses have codified support (and correctly substitute pronouns) and others do not (and rely on a generic `pose` system).

## Extra-narrative Information

Interactive fiction mixes narrative and extra-narrative information into the prose freely. Even discounting the player's input (which generally has a different tone and structure than the game's narrative), various gameplay situations require the presentation of non-narrative information. For example, nonsense inputs require _some_ response, so that the player understands that the game hasn't understood hem, but that response describes the input-processing behaviour of the game, and doesn't narrate the story the game is telling.

Most IF games present this output through the same prose flow as the game's narrative, mixed indifferently with descriptive text. The obvious alternatives (of non-textual or non-narrative output) is, empirically, distracting: it forcibly reminds players that they're interacting with a machine, while prosaic output blends acceptably with the narrative. Thus:

> `> flarp`
>
> I didn't understand that.

is preferable to a beep, or to turning the input region another colour.

For some reason, this is one of the few situations where IF narrators refer to _themselves_. Is the narrator in fact a mediator, with an active role in the story being told?

