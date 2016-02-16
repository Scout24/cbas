import os
import getpass
import textwrap

import click
import yamlreader

from cbas.password_providers import DEFAULT_PASSWORD_PROVIDER

DEFAULT_CONFIG_PATH = "~/.cbas"


class CBASConfig(object):

    def __init__(self,
                 username=None,
                 auth_url=None,
                 client_secret=None,
                 password_provider=DEFAULT_PASSWORD_PROVIDER,
                 jump_host=None,
                 ):
        self.username = getpass.getuser()
        self.auth_url = auth_url
        self.client_secret = client_secret
        self.password_provider = password_provider
        self.jump_host = jump_host

    def __str__(self):
        return textwrap.dedent("""
             {{'username': '{username}',
               'auth_url': '{auth_url}',
               'client_secret': '{client_secret}',
               'password_provider': '{password_provider}',
               'jump_host': '{jump_host}',
             }}""").strip().replace('\n', '').format(
                 username=self.username,
                 auth_url=self.auth_url,
                 client_secret=self.client_secret,
                 password_provider=self.password_provider,
                 jump_host=self.jump_host,
                 )

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
