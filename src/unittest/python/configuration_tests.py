import unittest
from mock import patch, Mock

from cbas.configuration import CBASConfig


class TestCBASConfig(unittest.TestCase):

    @patch('getpass.getuser', Mock(return_value='ANY_USER'))
    def test_default_initialization(self):
        config = CBASConfig()
        self.assertEqual(config.username, 'ANY_USER')
        self.assertEqual(config.auth_url, None)
        self.assertEqual(config.client_secret, None)
        self.assertEqual(config.password_provider, 'prompt')
        self.assertEqual(config.jump_host, None)

    @patch('getpass.getuser', Mock(return_value='ANY_USER'))
    def test_str_defaults(self):
        config = CBASConfig()
        expected = eval("{'username': 'ANY_USER', "
                        "'auth_url': None, "
                        "'client_secret': None, "
                        "'password_provider': 'prompt', "
                        "'jump_host': None}"
                        )
        received = eval(str(config))
        self.assertEqual(expected, received)

    @patch('getpass.getuser', Mock(return_value='NO_USER'))
    def test_inject(self):
        config = CBASConfig()
        to_inject = {
            'username': 'ANY_USER',
            'auth_url': 'ANY_URL',
            'client_secret': 'ANY_SECRET',
            'password_provider': 'ANY_PROVIDER',
            # exclude jump_host to make sure it remains None
        }
        config.inject(to_inject)
        self.assertEqual(config.username, 'ANY_USER')
        self.assertEqual(config.auth_url, 'ANY_URL')
        self.assertEqual(config.client_secret, 'ANY_SECRET')
        self.assertEqual(config.password_provider, 'ANY_PROVIDER')
        self.assertEqual(config.jump_host, None)

