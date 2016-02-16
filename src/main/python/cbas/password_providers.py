import getpass

import keyring

from cbas.messages import CMDLineExit, debug, info

PROMPT = 'prompt'
KEYRING = 'keyring'
TESTING = 'testing'
PASSWORD_PROVIDERS = [PROMPT, KEYRING, TESTING]
DEFAULT_PASSWORD_PROVIDER = PROMPT


def prompt_get_password(username):
    """Return password for the given user"""
    return getpass.getpass("Password for {0}: ".format(username))


def keyring_get_password(username):

    keyring_impl = keyring.get_keyring()
    debug("Note: will use the backend: '{0}'".format(keyring_impl))
    password = keyring.get_password('cbas', username)
    if not password:
        info("No password found in keychain, please enter it now to store it.")
        password = prompt_get_password(username)
        keyring.set_password('cbas', username, password)
    return password


def get_password(password_provider, username):
    if password_provider == PROMPT:
        password = prompt_get_password(username)
    elif password_provider == KEYRING:
        password = keyring_get_password(username)
    elif password_provider == TESTING:
        password = 'PASSWORD'
    else:
        raise CMDLineExit("'{0}' is not a valid password provider.\n".
                          format(password_provider) +
                          "Valid options are: {0}".
                          format(PASSWORD_PROVIDERS))

    return password
