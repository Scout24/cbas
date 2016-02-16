import os
import getpass
import textwrap

import click
import yamlreader

from cbas.password_providers import DEFAULT_PASSWORD_PROVIDER

DEFAULT_CONFIG_PATH = "~/.cbas"


class CBASConfig(object):

    options = {'username': lambda: getpass.getuser(),
               'auth_url': None,
               'client_secret': None,
               'password_provider': DEFAULT_PASSWORD_PROVIDER,
               'jump_host': None,
               }

    def __init__(self):
        for option, default in self.options.iteritems():
            self.__dict__[option] = (default()
                                     if hasattr(default, '__call__')
                                     else default)

    def __str__(self):
        return str(dict(((option, self.__dict__[option])
                         for option in self.options)))

    @staticmethod
    def read(ctx, param, value):
        config = ctx.ensure_object(CBASConfig)
        config_path = os.path.expanduser(value)
        if os.path.exists(config_path):
            loaded_config = yamlreader.yaml_load(config_path)
            if 'username' in loaded_config:
                config.username = loaded_config['username']
            if 'auth-url' in loaded_config:
                config.auth_url = loaded_config['auth-url']
            if 'client-secret' in loaded_config:
                config.client_secret = loaded_config['client-secret']
            if 'password-provider' in loaded_config:
                config.password_provider = loaded_config['password-provider']
            if 'jump-host' in loaded_config:
                config.jump_host = loaded_config['jump-host']
        return config


pass_config = click.make_pass_decorator(CBASConfig, ensure=True)
