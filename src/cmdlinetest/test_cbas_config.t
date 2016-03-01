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
   'username': 'vhaenel'}
  [1]

# Test incomplete configuration with verbose

  $ cbas -v upload 
  Default config is:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': 'vhaenel'}
  Some config options are missing:
  {'auth_url': None,
   'client_secret': None,
   'jump_host': None,
   'password_provider': 'prompt',
   'ssh_key_file': '~/.ssh/id_rsa.pub',
   'username': 'vhaenel'}
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
   'username': 'vhaenel'}
  [1]
