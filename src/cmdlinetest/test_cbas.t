#!/usr/bin/env cram
# vim: set syntax=cram :

# test the help

  $ cbas --help
  Usage: cbas [OPTIONS] COMMAND [ARGS]...
  
  Options:
    --help  Show this message and exit.
  
  Commands:
    delete
    upload

  $ cbas
  Usage: cbas [OPTIONS] COMMAND [ARGS]...
  
  Options:
    --help  Show this message and exit.
  
  Commands:
    delete
    upload

  $ cbas upload
  Usage: cbas upload [OPTIONS] JUMPHOST
  
  Error: Missing argument "jumphost".
  [2]
