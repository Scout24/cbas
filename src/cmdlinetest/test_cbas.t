#!/usr/bin/env cram
# vim: set syntax=cram :

# test the help

  $ cbas --help
  Usage: cbas [OPTIONS] COMMAND [ARGS]...
  
  Options:
    -v, --verbose                 Activate verbose mode.
    -c, --config PATH             Path to config file.
    -u, --username TEXT           Username.
    -a, --auth-url TEXT           Auth-server URL.
    -s, --client-secret TEXT      Special client secret, ask mum.
    -p, --password-provider TEXT  Password provider.
    -h, --jump-host TEXT          Jump host to connect with.
    -k, --ssh-key-file TEXT       SSH Identity to use.
    --version                     Print version and exit.
    --help                        Show this message and exit.
  
  Commands:
    delete  Delete user.
    upload  Upload ssh-key and create user
