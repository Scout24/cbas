import unittest
from mock import patch, Mock

import urlparse

import requests_mock

from cbas.auth_server import obtain_access_token

class TestObtainAccessToken(unittest.TestCase):

    @requests_mock.mock()
    def test_obtain_access_token(self, rmock):
        rmock.post(requests_mock.ANY, text='{"access_token": "ANY_TOKEN"}')
        cmock = Mock()
        cmock.username = "ANY_USERNAME"
        cmock.client_secret = "ANY_SECRET"
        cmock.auth_url = "https://ANY_URL.example"
        result = obtain_access_token(cmock, 'ANY_PASSWORD')
        self.assertEqual('ANY_TOKEN', result)
        received_post_data = urlparse.parse_qs(rmock.request_history[0].text)
        expected_post_data = {u'username': [u'ANY_USERNAME'],
                              u'client_secret': [u'ANY_SECRET'],
                              u'password': [u'ANY_PASSWORD'],
                              u'client_id': [u'jumpauth'],
                              u'grant_type': [u'password']}
        self.assertEqual(received_post_data, expected_post_data)
