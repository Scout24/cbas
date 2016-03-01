#!/usr/bin/env cram
# vim: set syntax=cram :

# test the help

  $ cbas -v --help
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

# Start the mocked auth & cbastion server

  $ cp "$TESTDIR/mocked_cbastion.py" .
  $ ./mocked_cbastion.py >/dev/null 2>&1 &
  $ MOCK_PID=$!
  $ echo $MOCK_PID
  \d+ (re)

# Make a test home

  $ mkdir test-home
  $ export HOME=test-home

# Maybe wait for the bottle server to start

  $ sleep 1
  $ echo "supar-successful-pubkey" >pubkey.pub

# Test that a HTTP 400 from the auth server raises an error

  $ cbas -v -u auth_fail -p testing -k pubkey.pub -h localhost -s client_secret -a http://localhost:8080/oauth/token upload
  Default config is:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
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

  $ cbas -v -u user_ok -p testing -k pubkey.pub -h localhost:8080 -s client_secret -a http://localhost:8080/oauth/token upload
  Default config is:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
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
  $ cbas -v -u create_fail -p testing -k pubkey.pub -h localhost:8080 -s client_secret -a http://localhost:8080/oauth/token upload
  Default config is:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
  Password provider is: 'testing'
  Will now attempt to obtain an JWT...
  Authentication OK!
  Access token was received.
  Access token is:
  'the-token-with-which-create-will-fail'
  Will now attempt to upload your ssh-key...
  Upload failed: Permission denied
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

  $ cbas -v -u user_ok -p testing -h localhost:8080 -s client_secret -a http://localhost:8080/oauth/token delete
  Default config is:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
  Password provider is: 'testing'
  Will now attempt to obtain an JWT...
  Authentication OK!
  Access token was received.
  Access token is:
  'my-nifty-access-token'
  Will now attempt to delete your user...
  Delete OK!

# Test a negative case for user deletion

  $ cbas -v -u delete_fail -p testing -h localhost:8080 -s client_secret -a http://localhost:8080/oauth/token delete
  Default config is:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
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
