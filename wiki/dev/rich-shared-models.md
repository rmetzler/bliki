# Rich Shared Models Must Die

In a gaming system I once worked on, there was a single class which was
responsible for remembering everything about a user: their name and contact
information, their wagers, their balance, and every other fact about a user
the system cared about. In a system I'm working with now, there's a set of
classes that collaborate to track everything about the domain: prices,
descriptions, custom search properties, and so on.

Both of these are examples of shared, system-wide models.

Shared models are evil.

Shared models _must be destroyed_.

A software system's model is the set of functions and data types it uses to
decide what to do in response to various events. Models embody the development
team's assumptions and knowledge about the problem space, and usually reflect
the structure of the applications that use them. Not all systems have explicit
models, and it's often hard to draw a line through the code base separating
the code that is the model from the code that is not as every programmer sees
models slightly differently.

With the rise of object-oriented development, explicit models became the focus
of several well-known practices. Many medium-to-large projects are built
“model first,” with the interfaces to that model being sketched out later in
the process. Since the model holds the system's understanding of its task,
this makes sense, and so long as you keep the problem you're actually solving
in mind, it works well. Unfortunately, it's too easy to lose sight of the
problem and push the model as the whole reason for the system around it. This,
in combination with both emotional and technical investment in any existing
system, strongly encourages building `new` systems around the existing
model pieces even if the relationship between the new system is tenuous at
best.

* Why do we share them?
    * Unmanaged growth
        * Adding features to an existing system
        * Building new systems on top of existing tools
    * Misguided applications of “simplicity” and “reuse”
    * Encouraged by distributed object systems (CORBA, EJB, SOAP, COM)
* What are the consequences?
    * Models end up holding behaviour and data relevant to many applications
    * Every application using the model has to make the same assumptions
    * Changing the model usually requires upgrading everyone at the same time
    * Changes to the model are risky and impact many applications, even if the
      changes are only relevant to one application
* What should we do instead?
    * Narrow, flat interfaces
    * Each system is responsible for its own modelling needs
    * Systems share data and protocols, not objects
    * Libraries are good, if the entire world doesn't need to upgrade at the
      same time

It's easy to start building a system by figuring out what the various nouns it
cares about are. In the gambling example, one of our nouns was a user (the guy
sitting at a web browser somewhere), who would be able to log in, deposit
money, place a wager, and would have to be notified when the wager was
settled. This is a clear, reasonable entity for describing the goal of placing
bets online, which we could make reasonable assumptions about. It's also a
terrible thing to turn into a class.

The User class in our gambling system was responsible for all of those things;
as a result, every part of the system ended up using a User object somewhere.
Because the User class had many responsibilities, it was subject to frequent
changes; because it was used everywhere, those changes had the capability to
break nearly any part of the overall system. Worse, because so much
functionality was already in one place, it became psychologically easy to add
one more responsibility to its already-bloated interface.

What had been a clean model in the problem space eventually became one of a
handful of “glue” pieces in a [big ball of
mud](http://www.laputan.org/mud/mud.html#BigBallOfMud) program. The User
object did not come about through conscious design, but rather through
evolution from a simple system. There was no clear point where User became
“too big”; instead, the vagueness of its role slowly grew until it became the
default behaviour-holder for all things user-specific.

The same problem modeling exercise also points at a better way to design the
same system: it describes a number of capabilities the system needed to be
able to perform, each of which is simpler than “build a gaming website.” Each
of these capabilities (accept or reject logins, process deposits, accept and
settle wagers, and send out notification emails to players) has a much simpler
model and solves a much more constrained of problem. There is no reason the
authentication service needs to share any data except an identity with the
wagering service: one cares about login names, passwords, and authorization
tickets while the other cares about accounting, wins and losses, and posted
odds.

There is a small set of key facts that can be used to correlate all of pieces:
usernames, which uniquely identify a user, can be used to associate data and
behaviour in the login domain with data and behaviour in the accounting and
wagering domain, and with information in a contact management domain. All of
these key facts are flat—they have very little structure and no behaviour, and
can be passed from service to service without dragging along an entire
application's worth of baggage data.

Sharing model classes between many services creates a huge maintenance
bottleneck. Isolating models within the services they support helps encourage
clean separations between services, which in turn makes it much easier to
understand individual services and much easier to maintain the system as a
whole. Kindergarten lied: sharing is _wrong_.
