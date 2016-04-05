import collections
import os
import getpass
import pprint

import click
import yamlreader
import yaml

from cbas.password_providers import PROMPT
from cbas.log import verbose, info

DEFAULT_CONFIG_PATH = "~/.cbas"
DEFAULT_PASSWORD_PROVIDER = PROMPT
DEFAULT_SSH_KEY_FILE = '~/.ssh/id_rsa.pub'

pp = pprint.PrettyPrinter(indent=1)


class UnexpectedConfigValues(Exception):
    pass


class MissingConfigValues(Exception):
    pass


class CBASConfig(collections.MutableMapping):
    options = {'username': lambda: getpass.getuser(),
               'auth_host': None,
               'password_provider': DEFAULT_PASSWORD_PROVIDER,
               'jump_host': None,
               'ssh_key_file': DEFAULT_SSH_KEY_FILE,
               }

    def __init__(self):
        for option, default in self.options.items():
            self[option] = (default()
                            if hasattr(default, '__call__')
                            else default)
        verbose("Default config is:\n{0}".format(self))

    def __str__(self):
        return self.yaml_format(self)

    @property
    def _class_name(self):
        return type(self).__name__

    def __getitem__(self, key):
        if key not in self.options:
            raise KeyError('%s not in %s' % (key, self._class_name))
        return getattr(self, key)

    def __setitem__(self, key, value):
        if key not in self.options:
            raise KeyError('%s not in %s' % (key, self._class_name))
        setattr(self, key, value)

    def __delitem__(self, key):
        raise NotImplementedError(
            '%s does not support __delitem__ or derivatives'
            % self._class_name)

    def __len__(self):
        return len(self.options)

    def __iter__(self):
        return iter(self.options)

    def inject(self, new_options):
        for option in self.options:
            if option in new_options and new_options[option] is not None:
                self[option] = new_options[option]

    def is_complete(self):
        if not all(self.values()):
            raise MissingConfigValues(
                'Some config options are missing, active config is:\n{0}'.format(self))
        return True

    def validate_options(self, loaded_options):
        valid_values_hyphen = {(k.replace('_', '-')
                                for k in CBASConfig.options)}
        valid_values_underscore = set(CBASConfig.options)
        valid_values = valid_values_hyphen.union(valid_values_underscore)
        unexpected_values = set(loaded_options).difference(valid_values)
        if unexpected_values:
            raise UnexpectedConfigValues(
                'The following unexpected options were detected in configuration: {0}'.format(", ".join(unexpected_values)))
        return True

    def load_config(self, config_path):
        basic_loaded_config = yamlreader.yaml_load(config_path)
        return dict(((k.replace('-', '_'), v)
                     for k, v in basic_loaded_config.items()))

    @staticmethod
    def yaml_format(data):
        return yaml.safe_dump(dict(data), default_flow_style=False, explicit_start=True, explicit_end=True)

    @staticmethod
    def read(ctx, param, value):
        config = ctx.ensure_object(CBASConfig)
        config_path = os.path.expanduser(value)
        if os.path.exists(config_path):
            verbose("Config path is: {0}".format(config_path))
            loaded_config = config.load_config(config_path)
            config.validate_options(loaded_config)
            verbose("Loaded values from config file are:\n{0}".
                    format(CBASConfig.yaml_format(loaded_config)))
            config.inject(loaded_config)
            verbose("Processed config after loading:\n{0}".format(CBASConfig.yaml_format(config)))
        return config


pass_config = click.make_pass_decorator(CBASConfig, ensure=True)
