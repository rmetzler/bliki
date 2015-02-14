# Compiling TinyFugue on Yosemite

TinyFugue's site claims that it works on OS X. This is largely true, but the
switch from `gcc` to `clang` has eliminated support for some _deeply_ legacy
symbols.

Since SourceForge is a death zone, I'll post my fix here. To get TinyFugue to
compile, apply the following patch:

    --- src/malloc.c.orig	2015-02-13 23:45:44.000000000 -0500
    +++ src/malloc.c	2015-02-13 23:45:28.000000000 -0500
    @@ -12,7 +12,6 @@
     #include "signals.h"
     #include "malloc.h"
    
    -caddr_t mmalloc_base = NULL;
     int low_memory_warning = 0;
     static char *reserve = NULL;

This symbol appears to be unused. Certainly I haven't been able to find any
references, and `tf` works well enough.
