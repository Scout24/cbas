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

