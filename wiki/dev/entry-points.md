# Entry Points

The following captures a conversation from IRC:

> [Owen J](https://twitter.com/derspiny): Have you run across the idea
> of an "entry point" in a runtime yet? (You've definitely used it, just
> possibly not known it had a name.)
>
> [Alex L](https://twitter.com/aeleitch): I have not!
>
> [Owen J](https://twitter.com/derspiny): It's the point where the
> execution of the outside system -- the OS, the browser, the Node
> runtime, whatever -- stops and the execution of your code starts. Some
> platforms only give you one: C on Unix is classic, where there's only
> two entry points: main and signal handlers (and a lot of apps only use
> main). JS gives you _a shit fucking ton_ of entry points.
>
> [Owen J](https://twitter.com/derspiny): In a browser, the pageload
> process is an entry point: your code gets run when the browser
> encounters a `<script>` tag. So is every event handler. There's none
> of your code running when an event handler starts, only the browser
> is running. So is every callback from an external service, like
> `XmlHttpRequest` or `EventSource` or the `File` APIs. In Node, the top
> level of your main script is an entry point, but so is every callback
> from an external service.
>
> [Alex L](https://twitter.com/aeleitch): Ahahahahahahaha oh my
> god. There is no way for me to contain them all. _everything the light
> touches._
>
> [Owen J](https://twitter.com/derspiny): This is important for
> reasoning about exception handling! _In JS_, exception handling only
> propagates one direction: towards the entry point of this sequence of
> function calls.
>
> [Alex L](https://twitter.com/aeleitch): Yes. This is what _I_ call a
> stack trace.
>
> [Owen J](https://twitter.com/derspiny): If an exception escapes from
> an entry point, the JS runtime logs it, and then the outside runtime
> takes over again. That's one of the ways callbacks from external
> services fuck up the idea of a stack trace as a map of control flow.
>
> [Alex L](https://twitter.com/aeleitch): Huh. Yes. Yes I can see
> that. I mean, in my world, control flow is a somewhat handwavey idea
> right now. I'm starting to understand why so many people hate JS-land.
>
> [Owen J](https://twitter.com/derspiny): Sure. But, for example, a
> promise chain is a tool for restructuring control flow. In principle,
> error handling should provide _some_ kind of map of that, to allow
> programmers -- you -- to diagnose how a program reached a given error
> state and maybe one day fix the problem. In THIS future, none of them
> do that well, though.
>
> [Alex L](https://twitter.com/aeleitch): Yes. Truly the darkest
> timeline, but this reviews why I am having these concerns.
