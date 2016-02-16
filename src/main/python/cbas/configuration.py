import os
import getpass

import click
import yamlreader

from cbas.password_providers import PROMPT

DEFAULT_CONFIG_PATH = "~/.cbas"
DEFAULT_PASSWORD_PROVIDER = PROMPT
DEFAULT_SSH_KEY_FILE = '~/.ssh/id_rsa.pub'


class CBASConfig(object):

    options = {'username': lambda: getpass.getuser(),
               'auth_url': None,
               'client_secret': None,
               'password_provider': DEFAULT_PASSWORD_PROVIDER,
               'jump_host': None,
               'ssh_key_file': DEFAULT_SSH_KEY_FILE
               }

    def __init__(self):
        for option, default in self.options.iteritems():
            self.__dict__[option] = (default()
                                     if hasattr(default, '__call__')
                                     else default)

    def __str__(self):
        return str(dict(((option, self.__dict__[option])
                         for option in self.options)))

    def inject(self, new_options):
        for option in self.options:
            if option in new_options and new_options[option] is not None:
                self.__dict__[option] = new_options[option]

    @staticmethod
    def load_config(config_path):
        basic_loaded_config = yamlreader.yaml_load(config_path)
        return dict(((k.replace('-', '_'), v)
                     for k, v in basic_loaded_config.iteritems()))

    @staticmethod
    def read(ctx, param, value):
        config = ctx.ensure_object(CBASConfig)
        config_path = os.path.expanduser(value)
        loaded_config = config.load_config(config_path)
        config.inject(loaded_config)
        return config


pass_config = click.make_pass_decorator(CBASConfig, ensure=True)
