# Git Internals 101

Yeah, yeah, another article about "how Git works". There are tons of these
already. Personally, I'm fond of Sitaram Chamarty's [fantastic series of
articles](http://gitolite.com/master-toc.html) explaining Git from both ends,
and of [Git for Computer
Scientists](http://eagain.net/articles/git-for-computer-scientists/). Maybe
you'd rather read those.

This page was inspired by very specific, recurring issues I've run into while
helping people use Git. I think Git's "porcelain" layer -- its user interface
-- is terrible, and does a bad job of insulating non-expert users from Git's
internals. While I'd love to fix that (and I do contribute to discussions on
that front, too), we still have the `git(1)` UI right now and people still get
into trouble with it right now.

Git follows the New Jersey approach laid out in Richard Gabriel's [The Rise of
"Worse is Better"](http://www.jwz.org/doc/worse-is-better.html): given the
choice between a simple implementation and a simple interface, Git chooses the
simple implementation almost everywhere. This internal simplicity can give
users the leverage to fix the problems that its horrible user interface leads
them into, so these pages will focus on explaining the simple parts and giving
users the tools to examine them.

Throughout these articles, I've written "Git does X" a lot. Git is
_incredibly_ configurable; read that as "Git does X _by default_". I'll try to
call out relevant configuration options as I go, where it doesn't interrupt
the flow of knowledge.

* [Objects](objects)
* [Refs and Names](refs-and-names)

By the way, if you think you're just going to follow the
[many](http://git-scm.com/documentation)
[excellent](http://www.atlassian.com/git/tutorial)
[git](http://try.github.io/levels/1/challenges/1)
[tutorials](https://www.kernel.org/pub/software/scm/git/docs/gittutorial.html)
out there and that you won't need this knowledge, well, you will. You can
either learn it during a quiet time, when you can think and experiment, or you
can learn it when something's gone wrong, and everyone's shouting at each
other. Git's high-level interface doesn't do much to keep you on the sensible
path, and you will eventually need to fix something.