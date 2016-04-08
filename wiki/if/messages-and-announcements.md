# Messages and Announcements

## Motivation

Maintain a prosaic tone and delivery throughout interactions with the simulation.

Support gameplay elements that alter the character's perception of the world, and represent those effects to the player.

## Ultimate Disposition

All messages are eventually disposed in one of two ways:

* displayed, marked up, on the web UI, or
* discarded.

For the purposes of the following, the builtin function `notify()` delivers raw Markdown to the UI, which handles markup conversion and presentation. The method `:notify(args...)` applies unspecified transformations on `args...` before delivering the result to `notify()`.

## Kinds of Messages

* Diegetic messages deliver an approximation of the sensory response to events in the simulated environment.

    * Diegetic messages should be tagged, internally, with the sense or senses perceiving the events, so that simulated sensory effects can modulate the message. It should be possible for a deaf character's player to "see" lips moving, while a fully-hearing character's player should insead "hear" the words spoken.

* Non-diegetic messages deliver information about the state of the simulation, or about the player's interaction with the simulator.

## Processing Models

### Parallel Entry Points

In this model, there are separate entry point methods for diegetic and for non-diegetic messages. Each entry point performs appropriate processing, then calls into internal methods shared by both message forms to deliver messages to the UI.

This model requires more names and is slightly more complex to explain, but splits the responsibility for output delivery from the responsibility for accepting non-diegetic messages, leaving each piece conceptually simpler.

### Diegetic Filter Methods

In this model, the internal methods are the entry point for non-diegetic messages directly, as they have no processing to perform. Diegetic messages instead call the non-diegetic machinery after performing any diegetic message effects.

This model requires fewer names, and avoids what will in practice be a layer of "do-nothing" methods where non-diegetic entry points blindly call internal helpers, but combines the responsibility for non-diegetic output with message delivery.

## APIs

### Primary Diegetic Verbs

* `recipient:you_SENSE(args...)`: a family of methods for delivering diegetic messages. Each SENSE (`you_hear`, `you_see`, `you_smell`, `you_feel`, `you_taste`) either delivers args to `recipient:notify` (see below) and returns `$true` (indicating that the recipient was capable of experiencing that sense) or ignores the arguments and returns `$false` (indicating that the recipient was not capable of experiencing that sense).

    The default implementation is equivalent to `return this:notify(@args);`.

* `recipient:you_SENSE_lines(lines)`: applies with `you_sense` to the elements of `lines` in order, each of which must either be a single string (passed as the first argument of the corresponding `you_SENSE`) or a list (passed as the argument list to the corresponding `you_SENSE`). Returns `$true` if every line is accepted by `you_SENSE`, or `$false` if any line is rejected. Processing stops at the first rejected line.

These methods are designed to be chained, to make it simpler to simulate partial impairment while allowing the game's prose to focus on the most appropriate "available" sense for each character.

```
player:you_hear(spoken_message) || player:you_see(lips_moving_message);
```

In spite of the names, these methods _do not_ prepend "You hear" to the output. The naming distinguishes single-recipient messages meant to be sensed by a single object from messages to be delivered to the occupants of a container or room:

* `room:SENSE(args...)`: calls `you_SENSE(args...)` on every occupant of `room` who is not than `player`. Returns a list of objects for which `you_SENSE` returned `$false`, for use in `room:SENSE_only` (below). Skips `player`, to ease simulating situations where the character's self-perception has unique prose ("You say" vs. "Toby says").
* `room:SENSE_all(args...)`: calls `you_SENSE(args...)` on every occupant of `room`. As with `room:SENSE`, this returns a list of objects that were unable to sense the simulated event.
* `room:SENSE_all_but(nonrecipients, args...)`: calls `you_SENSE(args...)` on every occupant of `room` that is not in `nonrecipients`. As with `room:SENSE`, this returns a list of objects that meet those criteria that were unable to sense the simulated event.
* `room:SENSE_only(recipients, args...)`: calls `you_SENSE(args...)` on every occupant of `room` who is in `recipients`. Returns a list of objects that are in `room`, which are in `recipients`, which could not `you_SENSE` the message.

As with the single-recipient methods, these are meant to be chained, but the structure of a chain is different:

```
player:you_hear(you_say_message) || player:you_feel(your_lips_move_message);
unsensed = room:hear(heard_say_message);
unsensed = room:see_only(unsensed, lips_moving_message);
unsensed = room:smell_only(unsensed, smelly_breath_message);
```

### Primary Non-Diegetic Verbs

* `recipient:tell(args...)`: a method for delivering non-diegetic messags. Delivers `args` to `recipient:notify` unaltered. Returns nothing.

* `recipient:tell_lines(lines)`: applies `tell` to the elements of `lines` in order, each of which must either be a single string (passed as the first argument of `tell`) or a list (passed as the argument list to `tell`). Returns nothing.

* `room:announce(args...)`, `room:announce_all(args...)`, `room:announce_all_but(nonrecipients, args...)`, and `room:announce_only(recipients, args...)` mirror the behaviour of their diegetic equivalents, calling `tell` on each appropriate occupant. However, these methods return nothing, as they are not expected to be chained.
