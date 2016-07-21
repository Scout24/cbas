#!/usr/bin/env cram
# vim: set syntax=cram :

# test the help

  $ cbas --help
  Usage: cbas [OPTIONS] COMMAND [ARGS]...
  
  Options:
    -v, --verbose                   Activate verbose mode.
    -c, --config <config_path>      Path to config file. Default: '~/.cbas'.
    -u, --username <username>       Username. Default: the logged in user.
    -k, --ssh-key-file <key-file>   SSH Identity to use. Default:
                                    '~/.ssh/id_rsa.pub'.
    -p, --password-provider <provider>
                                    Password provider. Default: 'prompt'.
    -a, --auth-host <host>          Auth-server host.
    -h, --jump-host <host>          Jump host to connect with.
    --version                       Print version and exit.
    --help                          Show this message and exit.
  
  Commands:
    dry_run  Dry run, sanitize all config only.
    upload   Upload ssh-key and create user.

# Start the mocked auth & cbastion server

  $ cp "$TESTDIR/mocked_cbastion.py" .
  $ ./mocked_cbastion.py >/dev/null 2>&1 &
  $ MOCK_PID=$!
  $ echo $MOCK_PID
  \d+ (re)

# Export the mock urls

  $ export JUMP_MOCK=http://localhost:8080
  $ export AUTH_MOCK=http://localhost:8080

# Make a test home

  $ mkdir test-home
  $ export HOME=test-home

# Maybe wait for the bottle server to start

  $ sleep 1
  $ echo "supar-successful-pubkey" >pubkey.pub

# Test that a HTTP 400 from the auth server raises an error

  $ cbas -u auth_fail -p testing -k pubkey.pub -h $JUMP_MOCK -a $AUTH_MOCK upload
  Will now attempt to obtain an JWT...
  Authentication failed: errored with HTTP 400 on request
  400 Client Error: Bad Request for url: http://localhost:8080/oauth/token
  [1]

# Test a successful creation

  $ cbas -u user_ok -p testing -k pubkey.pub -h $JUMP_MOCK -a $AUTH_MOCK upload
  Will now attempt to obtain an JWT...
  Authentication OK!
  Access token was received.
  Will now attempt to upload your ssh-key...
  Upload OK!

# Test a negative case when a user creation fails

  $ echo "" >pubkey.pub
  $ cbas -u create_fail -p testing -k pubkey.pub -h $JUMP_MOCK -a $AUTH_MOCK upload
  Will now attempt to obtain an JWT...
  Authentication OK!
  Access token was received.
  Will now attempt to upload your ssh-key...
  Upload failed: {"error": "Permission denied"}
  403 Client Error: Forbidden for url: http://localhost:8080/create
  [1]

# Test error message for an empty page

  $ cbas -u empty_page -p testing -k pubkey.pub -h $JUMP_MOCK -a $AUTH_MOCK upload
  Will now attempt to obtain an JWT...
  Authentication OK!
  Access token was received.
  Will now attempt to upload your ssh-key...
  Upload failed: empty
  403 Client Error: Forbidden for url: http://localhost:8080/create
  [1]

# Shut down the mocked cbastion/auth server

  $ rm pubkey.pub
  $ kill $MOCK_PID
