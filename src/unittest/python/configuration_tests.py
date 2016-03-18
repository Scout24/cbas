import unittest
from mock import patch, Mock

from cbas.configuration import CBASConfig, MissingConfigValues, UnexpectedConfigValues


class TestCBASConfig(unittest.TestCase):
    @patch('getpass.getuser', Mock(return_value='ANY_USER'))
    def test_default_initialization(self):
        config = CBASConfig()
        self.assertEqual(config.username, 'ANY_USER')
        self.assertEqual(config.auth_url, None)
        self.assertEqual(config.password_provider, 'prompt')
        self.assertEqual(config.jump_host, None)
        self.assertEqual(config.ssh_key_file, '~/.ssh/id_rsa.pub')

    @patch('getpass.getuser', Mock(return_value='ANY_USER'))
    def test_str_defaults(self):
        received = CBASConfig()
        expected = {'username': 'ANY_USER',
                    'auth_url': None,
                    'client_secret': None,
                    'password_provider': 'prompt',
                    'jump_host': None,
                    'ssh_key_file': '~/.ssh/id_rsa.pub'}

        self.assertEqual(expected, received)

    @patch('getpass.getuser', Mock(return_value='NO_USER'))
    def test_inject(self):
        config = CBASConfig()
        to_inject = {
            'username': 'ANY_USER',
            'auth_url': 'ANY_URL',
            'password_provider': 'ANY_PROVIDER',
            # exclude jump_host to make sure it remains None
        }
        config.inject(to_inject)
        self.assertEqual(config.username, 'ANY_USER')
        self.assertEqual(config.auth_url, 'ANY_URL')
        self.assertEqual(config.password_provider, 'ANY_PROVIDER')
        self.assertEqual(config.jump_host, None)

    @patch('yamlreader.yaml_load',
           Mock(return_value={'nospecial': 'ANY_VALUE_ONE',
                              'with-hyphen': 'ANY_VALUE_TWO',
                              'with-many-hyphens': 'ANY_VALUE_THREE',
                              'with_underscore': 'ANY_VALUE_FOUR',
                              'with_under_scores': 'ANY_VALUE_FIVE',
                              }))
    def test_load_config(self):
        config = CBASConfig()
        received = config.load_config('ANY_PATH')
        expected = {'nospecial': 'ANY_VALUE_ONE',
                    'with_hyphen': 'ANY_VALUE_TWO',
                    'with_many_hyphens': 'ANY_VALUE_THREE',
                    'with_underscore': 'ANY_VALUE_FOUR',
                    'with_under_scores': 'ANY_VALUE_FIVE',
                    }
        self.assertEqual(expected, received)

    @patch('os.path.exists', Mock(return_value=False))
    def test_read_without_loading(self):
        config = CBASConfig()
        expected = CBASConfig()
        mock_ctx = Mock()
        mock_ctx.ensure_object.return_value = config
        value = "ANY_PATH"
        received = config.read(mock_ctx, None, value)
        self.assertEqual(expected, received)

    @patch('os.path.exists', Mock(return_value=True))
    @patch('cbas.configuration.CBASConfig.load_config',
           Mock(return_value={'username': "ANY_USER"}))
    def test_read_with_loading(self):
        config = CBASConfig()
        mock_ctx = Mock()
        mock_ctx.ensure_object.return_value = config
        value = "ANY_PATH"
        received = config.read(mock_ctx, None, value)
        expected = CBASConfig()
        expected.username = "ANY_USER"
        self.assertEqual(expected, received)

    def test_failed_for_incomplete_config(self):
        incomplete = CBASConfig()
        self.assertRaises(MissingConfigValues, incomplete.is_complete)

    def test_success_for_complete_config(self):
        complete_config = CBASConfig()
        complete_config.auth_url = 'ANY_URL'
        complete_config.jump_host = 'ANY_HOST'
        self.assertTrue(complete_config.is_complete)

    def test_failed_for_invalid_options(self):
        config = CBASConfig()
        loaded_option = {'invalid_option': 'invalid_value'}

        self.assertRaises(UnexpectedConfigValues, config.validate_options, loaded_option)

    def test_success_for_valid_options(self):
        config = CBASConfig()
        loaded_option = {'username': 'invalid_value'}
        self.assertTrue(config.validate_options, loaded_option)


