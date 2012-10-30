# Notes towards automating deployment

This is mostly aimed at the hosted-apps folks; deploying packaged software for
end users requires a slightly different approach.

## Assumptions

1. You have one or more _services_ to deploy. (If not, what are you doing
here?)

2. Your services are tracked in _source control_. (If not, go sort that out,
then come back. No, seriously, _now_.)

3. You will be deploying your services to one or more _environments_. An
environment is an abstract thing: think "production", not
"web01.public.example.com". (If not, where, exactly, will your service run?)

4. For each service, in each environment, there are one or more _servers_ to
host the service. These servers are functionally identical. (If not, go pave
them and rebuild them using Puppet, Chef, CFengine, or, hell, shell scripts
and duct tape. An environment full of one-offs is the kind of hell I wouldn't
wish on my worst enemy.)

5. For each service, in each environment, there is a canonical series of steps
that produce a "deployed" system.
