from cbas.log import debug

import requests


def obtain_access_token(config, password):
    debug("Will now attempt to obtain an JWT...")
    auth_request_data = {'client_id': 'jumpauth',
                         'client_secret': config.client_secret,
                         'username': config.username,
                         'password': password,
                         'grant_type': 'password'}
    auth_response = requests.post(config.auth_url, auth_request_data)
    auth_response.raise_for_status()
    access_token = auth_response.json()['access_token']
    debug("Access token is:\n'{0}'".format(access_token))
