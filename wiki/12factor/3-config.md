# Factor 3: Config

[This section](http://www.12factor.net/config) advises using environment
variables for everything.

> [Owen J](https://twitter.com/derspiny): I think I disagree with
> 12factor's conclusions on config even though I agree with the premises
> and rationale in general
>
> [Owen J](https://twitter.com/derspiny): environment variables
> are neither exceptionally portable, exceptionally standard, nor
> exceptionally easy to manage
>
> [Owen J](https://twitter.com/derspiny): and therefore should not be
> the exceptional configuration mechanism :)
>
> [Kit L](https://twitter.com/wlonk): that's exactly the critique i have

Frustratingly, the config section doesn't provide any guidance on sensible
ways to _manage_ environment variables. In any real-world deployment, they're
going to have to be stored somewhere; where's appropriate? `.bash_profile`?
`httpd.con` as `SetEnv` directives? Per-release `rc` files? `/etc/init.d`?
