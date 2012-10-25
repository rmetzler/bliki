# Integrating with Git: A Field Guide

Pretty much everything you might want to do to a Git repository when writing
tooling or integrations should be done by shelling out to one `git` command or
another.

## Finding Git's trees

Git commands can be invoked from locations other than the root of the work
tree or git directory. You can find either of those by invoking `git
rev-parse`.

To find the absolute path to the root of the work tree:

    git rev-parse --show-toplevel

This will output the absolute path to the root of the work tree on standard
output, followed by a newline. Since the work tree's absolute path can contain
whitespace (including newlines), you should assume every byte of output save
the final newline is part of the path, and if you're using this in a shell
script, quote defensively.

To find the relative path from the current working directory:

    git rev-parse --show-cdup

This will output the relative path to the root of the work tree on standard
output, followed by a newline.

For bare repositories, both commands will output nothing and exit with a zero
status. (Surprise!)

To find *a* path to the root of the git directory:

    git rev-parse --git-dir

This will output either the relative or the absolute path to the git
directory, followed by a newline.

All three of these commands will exit with non-zero status when run outside of
a work tree or git directory. Check for it.
