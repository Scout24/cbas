import sys

import unittest
from mock import Mock

import requests_mock

from cbas.auth_server import obtain_access_token, get_auth_url

if sys.version_info[0] == 3:
    from urllib.parse import parse_qs
else:
    from urlparse import parse_qs


class TestGetAuthUrl(unittest.TestCase):

    def test_use_explicit_scheme(self):
        m = Mock(auth_host='http://ANY_HOST')
        self.assertEqual('http://ANY_HOST/oauth/token', get_auth_url(m))

    def test_prefix_https(self):
        m = Mock(auth_host='ANY_HOST')
        self.assertEqual('https://ANY_HOST/oauth/token', get_auth_url(m))

    def test_ignore_path_if_exists(self):
        m = Mock(auth_host='ANY_HOST/special/id/auth')
        self.assertEqual('https://ANY_HOST/special/id/auth', get_auth_url(m))



class TestObtainAccessToken(unittest.TestCase):

    @requests_mock.mock()
    def test_obtain_access_token(self, rmock):
        rmock.post(requests_mock.ANY, text='{"access_token": "ANY_TOKEN"}')
        cmock = Mock()
        cmock.username = "ANY_USERNAME"
        cmock.auth_host = "ANY_URL.example"
        result = obtain_access_token(cmock, 'ANY_PASSWORD')
        self.assertEqual('ANY_TOKEN', result)
        received_post_data = parse_qs(rmock.request_history[0].text)
        expected_post_data = {u'username': [u'ANY_USERNAME'],
                              u'password': [u'ANY_PASSWORD'],
                              u'client_id': [u'jumpauth'],
                              u'grant_type': [u'password']}
        self.assertEqual(received_post_data, expected_post_data)
