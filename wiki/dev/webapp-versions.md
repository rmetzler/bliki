# Semver Is Wrong For Web Applications

[Semantic Versioning](http://semver.org) (“Semver”) is a great idea, not least
because it's more of a codification of existing practice than a totally novel
approach to versioning. However, I think it's wrong for web applications.

Modern web applications tend to be either totally stagnant - in which case
versioning is irrelevant - or continuously upgraded. Users have no, or very
little, choice as to which version to run: either they run the version currently
on the site, or no version at all. Without the flexibility to choose to run a
specific version, Semver's categorization of versions by what compatibility
guarantees they offer is at best misleading and at worst irrelevant and
insulting.

Web applications must still be _versioned_; internal users and operators must be
able to trace behavioural changes through to deployments and backwards from
there to [code changes](commit-messages). The continuous and incremental nature
of most web development suggests that a simple, ordered version identifier may
be more appropriate: a [build](builds) serial number, or a version _date_, or
otherwise.

There are _parts_ of web applications that should be semantically versioned: as
the Semver spec says, “Once you identify your public API, you communicate
changes to it with specific increments to your version number,” and this remains
true on the web: whether you choose to support multiple API versions
simultaneously, or to discard all but the latest API version, a semantic version
number can be a helpful communication tool _about that API_.
