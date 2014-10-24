# Code Signing on Build Servers

We sign things so that we can authenticate them later, but authentication is
largely a conscious function. Computers are bad at answering "is this real".

Major signing systems (GPG, jarsigner) require presentation of credentials at
signing time. CI servers don't generally have safe tools for this.
