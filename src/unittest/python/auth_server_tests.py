import sys

import unittest
from mock import Mock

import requests_mock

from cbas.auth_server import obtain_access_token

if sys.version_info[0] == 3:
    from urllib.parse import parse_qs
else:
    from urlparse import parse_qs


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
