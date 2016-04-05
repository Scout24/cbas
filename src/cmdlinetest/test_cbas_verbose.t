#!/usr/bin/env cram
# vim: set syntax=cram :

# test the help

  $ cbas -v --help
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
    delete   Delete user.
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

  $ cbas -v -u auth_fail -p testing -k pubkey.pub -h $JUMP_MOCK -a $AUTH_MOCK upload
  Default config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  Values supplied on the command-line are:
  {'auth_host': u?'http://localhost:8080', (re)
   'jump_host': u?'http://localhost:8080', (re)
   'password_provider': u?'testing', (re)
   'ssh_key_file': u?'pubkey.pub', (re)
   'username': u?'auth_fail'} (re)
  Final aggregated config:
  ---
  auth_host: http://localhost:8080
  jump_host: http://localhost:8080
  password_provider: testing
  ssh_key_file: pubkey.pub
  username: auth_fail
  ...
  
  Password provider is: 'testing'
  Will now attempt to obtain an JWT...
  Authentication failed: errored with HTTP 400 on request
  400 Client Error: Bad Request for url: http://localhost:8080/oauth/token
  Traceback (most recent call last):
    File "*/scripts/cbas", line *, in <module> (glob)
      main()
    File "*/site-packages/click/core.py", line *, in __call__ (glob)
      return self.main(*args, **kwargs)
    File "*/site-packages/click/core.py", line *, in main (glob)
      rv = self.invoke(ctx)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return _process_result(sub_ctx.command.invoke(sub_ctx))
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return ctx.invoke(self.callback, **ctx.params)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return callback(*args, **kwargs)
    File "*/site-packages/click/decorators.py", line *, in new_func (glob)
      return ctx.invoke(f, obj, *args[1:], **kwargs)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return callback(*args, **kwargs)
    File "*/scripts/cbas", line *, in upload (glob)
      access_token = obtain_access_token(config, password)
    File "*/cbas/auth_server.py", line *, in obtain_access_token (glob)
      auth_response.raise_for_status()
    File "*/site-packages/requests/models.py", line *, in raise_for_status (glob)
      raise HTTPError(http_error_msg, response=self)
  requests.exceptions.HTTPError: 400 Client Error: Bad Request for url: http://localhost:8080/oauth/token
  [1]

# Test a successful creation

  $ echo "supar-successful-pubkey" >pubkey.pub

  $ cbas -v -u user_ok -p testing -k pubkey.pub -h $JUMP_MOCK -a $AUTH_MOCK upload
  Default config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  Values supplied on the command-line are:
  {'auth_host': u?'http://localhost:8080', (re)
   'jump_host': u?'http://localhost:8080', (re)
   'password_provider': u?'testing', (re)
   'ssh_key_file': u?'pubkey.pub', (re)
   'username': u?'user_ok'} (re)
  Final aggregated config:
  ---
  auth_host: http://localhost:8080
  jump_host: http://localhost:8080
  password_provider: testing
  ssh_key_file: pubkey.pub
  username: user_ok
  ...
  
  Password provider is: 'testing'
  Will now attempt to obtain an JWT...
  Authentication OK!
  Access token was received.
  Access token is:
  'my-nifty-access-token'
  Will now attempt to upload your ssh-key...
  Upload OK!

# Test a negative case when a user creation fails

  $ echo "" >pubkey.pub
  $ cbas -v -u create_fail -p testing -k pubkey.pub -h $JUMP_MOCK -a $AUTH_MOCK upload
  Default config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  Values supplied on the command-line are:
  {'auth_host': u?'http://localhost:8080', (re)
   'jump_host': u?'http://localhost:8080', (re)
   'password_provider': u?'testing', (re)
   'ssh_key_file': u?'pubkey.pub', (re)
   'username': u?'create_fail'} (re)
  Final aggregated config:
  ---
  auth_host: http://localhost:8080
  jump_host: http://localhost:8080
  password_provider: testing
  ssh_key_file: pubkey.pub
  username: create_fail
  ...
  
  Password provider is: 'testing'
  Will now attempt to obtain an JWT...
  Authentication OK!
  Access token was received.
  Access token is:
  'the-token-with-which-create-will-fail'
  Will now attempt to upload your ssh-key...
  Upload failed: {"error": "Permission denied"}
  403 Client Error: Forbidden for url: http://localhost:8080/create
  Traceback (most recent call last):
    File "*/scripts/cbas", line *, in <module> (glob)
      main()
    File "*/site-packages/click/core.py", line *, in __call__ (glob)
      return self.main(*args, **kwargs)
    File "*/site-packages/click/core.py", line *, in main (glob)
      rv = self.invoke(ctx)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return _process_result(sub_ctx.command.invoke(sub_ctx))
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return ctx.invoke(self.callback, **ctx.params)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return callback(*args, **kwargs)
    File "*/site-packages/click/decorators.py", line *, in new_func (glob)
      return ctx.invoke(f, obj, *args[1:], **kwargs)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return callback(*args, **kwargs)
    File "*/scripts/cbas", line *, in upload (glob)
      jump_response.raise_for_status()
    File "*/site-packages/requests/models.py", line *, in raise_for_status (glob)
      raise HTTPError(http_error_msg, response=self)
  requests.exceptions.HTTPError: 403 Client Error: Forbidden for url: http://localhost:8080/create
  [1]

# Test a positive case for user deletion

  $ cbas -v -u user_ok -p testing -h $JUMP_MOCK -a $AUTH_MOCK delete
  Default config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  Values supplied on the command-line are:
  {'auth_host': u?'http://localhost:8080', (re)
   'jump_host': u?'http://localhost:8080', (re)
   'password_provider': u?'testing', (re)
   'ssh_key_file': None, (re)
   'username': u?'user_ok'} (re)
  Final aggregated config:
  ---
  auth_host: http://localhost:8080
  jump_host: http://localhost:8080
  password_provider: testing
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: user_ok
  ...
  
  Password provider is: 'testing'
  Will now attempt to obtain an JWT...
  Authentication OK!
  Access token was received.
  Access token is:
  'my-nifty-access-token'
  Will now attempt to delete your user...
  Delete OK!

# Test a negative case for user deletion

  $ cbas -v -u delete_fail -p testing -h $JUMP_MOCK -a $AUTH_MOCK delete
  Default config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  Values supplied on the command-line are:
  {'auth_host': u?'http://localhost:8080', (re)
   'jump_host': u?'http://localhost:8080', (re)
   'password_provider': u?'testing', (re)
   'ssh_key_file': None, (re)
   'username': u?'delete_fail'} (re)
  Final aggregated config:
  ---
  auth_host: http://localhost:8080
  jump_host: http://localhost:8080
  password_provider: testing
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: delete_fail
  ...
  
  Password provider is: 'testing'
  Will now attempt to obtain an JWT...
  Authentication OK!
  Access token was received.
  Access token is:
  'the-token-with-which-delete-will-fail'
  Will now attempt to delete your user...
  Delete failed!
  403 Client Error: Forbidden for url: http://localhost:8080/delete
  Traceback (most recent call last):
    File "*/scripts/cbas", line *, in <module> (glob)
      main()
    File "*/site-packages/click/core.py", line *, in __call__ (glob)
      return self.main(*args, **kwargs)
    File "*/site-packages/click/core.py", line *, in main (glob)
      rv = self.invoke(ctx)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return _process_result(sub_ctx.command.invoke(sub_ctx))
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return ctx.invoke(self.callback, **ctx.params)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return callback(*args, **kwargs)
    File "*/site-packages/click/decorators.py", line *, in new_func (glob)
      return ctx.invoke(f, obj, *args[1:], **kwargs)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return callback(*args, **kwargs)
    File "*/scripts/cbas", line *, in delete (glob)
      jump_response.raise_for_status()
    File "*/site-packages/requests/models.py", line *, in raise_for_status (glob)
      raise HTTPError(http_error_msg, response=self)
  requests.exceptions.HTTPError: 403 Client Error: Forbidden for url: http://localhost:8080/delete
  [1]

# Shut down the mocked cbastion/auth server

  $ rm pubkey.pub
  $ kill $MOCK_PID
