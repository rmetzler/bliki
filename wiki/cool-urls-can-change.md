# Cool URLs Do Change (Sometimes)

Required reading: [Cool URLs don't
change](http://www.w3.org/Provider/Style/URI.html).

When I wrote [Nobody Cares About Your
Build](http://codex.grimoire.ca/2008/09/24/nobody-cares-about-your-build/), I
set up a dedicated publishing platform - Wordpress, as it happens - to host
it, and as part of that process I put some real thought into the choice of
"permalink" schemes to use. I opted to use a "dated" scheme, baking the
publication date of each article into its name - into its URL - for all
eternity. I'm a big believer in the idea that a URL should be a long-term name
for the appropriate bit of data or content, and every part of a dated scheme
"made sense" at the time.

This turned out to be a mistake.

The web is not, much, like print media. Something published may be amended;
you don't even have to publish errata or a correction, since you can correct
the original mistake "seamlessly". This has its good and its
[bad](http://en.wikipedia.org/wiki/Memory_hole) parts, but with judicious use
and a public history, amendment is more of a win than a loss. However, this
plays havoc with the idea of a "publication" date, even for data that takes
the form of an article: is the publication date the date it was first made
public, the date of its most recent edit, or some other date?

Because the name - the URL - of an article was set when I first published it,
the date in the name had to be its initial publication date. _This has
actually stopped me from making useful amendments to old articles_ because the
effort of writing a full, free-standing followup article is more than I'm
willing to commit to. Had I left the date out of the URLs, I'd feel more free
to judiciously amend articles in place and include, in the content, a short
amendment summary.

The W3C's informal suggestions on the subject state that "After the creation
date, putting any information in the name is asking for trouble one way or
another." I'm starting to believe that this doesn't go far enough: _every_
part of a URL must have some semantic justification for being there, dates
included:

1. *Each part must be meaningful*. While
    `http://example.com/WW91IGp1c3QgbG9zdCB0aGUgZ2FtZQ==` is fairly easy to
    render stable, the meaningless blob renders the name immemorable.

2. *Each part must be stable*. This is where I screwed up worst: I did not
    anticipate that the "date" of an article could be a fluid thing. It's
    tempting to privilege the first date, and it's not an unreasonable
    solution, but it didn't fit how I wanted to address the contents of
    articles.

Running a web server gives you one namespace to play with. Use it wisely.

## Ok, But I've Already Got These URLs

Thankfully, there's a way out - for _some_ URLs. URLs inherently name
resources _accessed using some protocol_, and some protocols provide support
for resources that are, themselves, references to other URLs. HTTP is a good
example, providing a fairly rich set of responses that all, fundamentally,
tell a client to check a second URL for the content relevent to a given URL.
In protocols like this, you can easily replace the content of a URL with a
reference to its new, "better" URL rather than abandoning it entirely.

Names can evolve organically as the humans that issue them grow a better
understanding of the problem, and don't always have to be locked in stone from
the moment they're first used.
