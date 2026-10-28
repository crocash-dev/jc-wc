# jc-wc 
## An Implementation of the UNIX/LINUX `wc` command
## A John Crickett Coding Challenge

This was a project from https://codingchallenges.fyi/ to implement my own version of the linux command `wc`.
My implementation works in accordance with the `man wc` page for the features:

- -c : Byte count of file(s) or STDIN
- -l : Line count of file(s) or STDIN
- -w : Word count of file(s) or STDIN
- -m : Char count of file(s) or STDIN

With the usage ./jc-wc -[arg] [file ...]

## Installation 

To build, install SBCL and quicklisp on your machine, clone the repo, and run `sbcl --script build.lisp` in the resultant directory.
