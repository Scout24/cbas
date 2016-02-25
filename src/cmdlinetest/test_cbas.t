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

# Start the mocked auth & cbastion server

  $ cp "$TESTDIR/mocked_cbastion.py" .
  $ ./mocked_cbastion.py >/dev/null 2>&1 &
  $ MOCK_PID=$!
  $ echo $MOCK_PID
  \d+ (re)

# Maybe wait for the bottle server to start

  $ sleep 1

# Test that a HTTP 400 from the auth server raises an error

  $ cbas -u return_400 -p testing -h localhost -s 5i5ptUm4LrJMyEGB -a http://localhost:8080/oauth/token upload
  Will now attempt to obtain an JWT...
  Authentication failed: errored with HTTP 400 on request
  Traceback (most recent call last):
    File "*/target/dist/cbas-*/scripts/cbas", line *, in <module> (glob)
      main()
    File "*site-packages/click/core.py", line *, in __call__ (glob)
      return self.main(*args, **kwargs)
    File "*site-packages/click/core.py", line *, in main (glob)
      rv = self.invoke(ctx)
    File "*site-packages/click/core.py", line *, in invoke (glob)
      return _process_result(sub_ctx.command.invoke(sub_ctx))
    File "*site-packages/click/core.py", line *, in invoke (glob)
      return ctx.invoke(self.callback, **ctx.params)
    File "*site-packages/click/core.py", line *, in invoke (glob)
      return callback(*args, **kwargs)
    File "*site-packages/click/decorators.py", line *, in new_func (glob)
      return ctx.invoke(f, obj, *args[1:], **kwargs)
    File "*site-packages/click/core.py", line *, in invoke (glob)
      return callback(*args, **kwargs)
    File "*/target/dist/cbas-*/scripts/cbas", line *, in upload (glob)
      access_token = obtain_access_token(config, password)
    File "*/target/dist/cbas-*/cbas/auth_server.py", line *, in obtain_access_token (glob)
      auth_response.raise_for_status()
    File "*site-packages/requests/models.py", line *, in raise_for_status (glob)
      raise HTTPError(http_error_msg, response=self)
  requests.exceptions.HTTPError: 400 Client Error: Bad Request for url: http://localhost:8080/oauth/token
  [1]

# Shut down the mocked cbastion/auth server

  $ kill $MOCK_PID
