#!/usr/bin/env cram
# vim: set syntax=cram :

# test the help

  $ cbas --help
  Usage: cbas [OPTIONS] JUMPHOST
  
  Options:
    --username TEXT
    --sshkey TEXT
    --password TEXT
    --help           Show this message and exit.

  $ cbas
  Usage: cbas [OPTIONS] JUMPHOST
  
  Error: Missing argument "jumphost".
  [2]
