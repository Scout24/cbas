#!/usr/bin/env cram
# vim: set syntax=cram :

# Make a test home

  $ mkdir test-home
  $ export HOME=test-home

# Test incomplete configuration

  $ cbas upload
  Some config options are missing:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
  [1]

# Test incomplete configuration with verbose

  $ cbas -v upload 
  Default config is:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
  Some config options are missing:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
  Traceback (most recent call last):
    File "*/scripts/cbas", line *, in <module> (glob)
      main()
    File "*/site-packages/click/core.py", line *, in __call__ (glob)
      return self.main(*args, **kwargs)
    File "*/site-packages/click/core.py", line *, in main (glob)
      rv = self.invoke(ctx)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      Command.invoke(self, ctx)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return ctx.invoke(self.callback, **ctx.params)
    File "*/site-packages/click/core.py", line *, in invoke (glob)
      return callback(*args, **kwargs)
    File "*/scripts/cbas", line *, in main (glob)
      config.is_complete()
    File "*/cbas/configuration.py", line *, in is_complete (glob)
      'Some config options are missing:\n{0}'.format(self))
  cbas.configuration.MissingConfigValues: Some config options are missing:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
  [1]

# Test unexpected config values

  $ echo "UNEXPECTED_KEY: UNEXPECTED_VALUE" > ~/.cbas
  $ cbas upload
  The following unexpected values were detected set(['UNEXPECTED_KEY'])
  [1]

# Test unexpected config values with verbose

  $ cbas -v upload
  Default config is:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': '*'} (glob)
  Config path is: test-home/.cbas
  The following unexpected values were detected set(['UNEXPECTED_KEY'])
  Traceback (most recent call last):
    File "*/scripts/cbas", line *, in <module> (glob)
      main()
    File "*/site-packages/click/core.py", line *, in __call__ (glob)
      return self.main(*args, **kwargs)
    File "*/site-packages/click/core.py", line *, in main (glob)
      with self.make_context(prog_name, args, **extra) as ctx:
    File "*/site-packages/click/core.py", line *, in make_context (glob)
      self.parse_args(ctx, args)
    File "*/site-packages/click/core.py", line *, in parse_args (glob)
      rest = Command.parse_args(self, ctx, args)
    File "*/site-packages/click/core.py", line *, in parse_args (glob)
      value, args = param.handle_parse_result(ctx, opts, args)
    File "*/site-packages/click/core.py", line *, in handle_parse_result (glob)
      self.callback, ctx, self, value)
    File "*/site-packages/click/core.py", line *, in invoke_param_callback (glob)
      return callback(ctx, param, value)
    File "*/scripts/cbas", line *, in read_wrapper (glob)
      return CBASConfig.read(ctx, param, value)
    File "*/cbas/configuration.py", line *, in read (glob)
      config.validate_options(loaded_config)
    File "*/cbas/configuration.py", line *, in validate_options (glob)
      'The following unexpected values were detected {0}'.format(unexpected_values))
  cbas.configuration.UnexpectedConfigValues: The following unexpected values were detected set(['UNEXPECTED_KEY'])
  [1]
