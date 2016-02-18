#!/usr/bin/env cram
# vim: set syntax=cram :

# test the help

  $ cbas --help
  Usage: cbas [OPTIONS] COMMAND [ARGS]...
  
  Options:
    -v, --verbose                   Activate verbose mode.
    -c, --config <config_path>      Path to config file.
    -u, --username <username>       Username.
    -a, --auth-url <auth_url>       Auth-server URL.
    -s, --client-secret <secret>    Special client secret, ask mum.
    -p, --password-provider <provider>
                                    Password provider.
    -h, --jump-host <host>          Jump host to connect with.
    -k, --ssh-key-file <key-file>   SSH Identity to use.
    --version                       Print version and exit.
    --help                          Show this message and exit.
  
  Commands:
    delete  Delete user.
    upload  Upload ssh-key and create user
