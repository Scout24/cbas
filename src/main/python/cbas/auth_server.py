from cbas.log import verbose, info

import requests


def obtain_access_token(config, password):
    info("Will now attempt to obtain an JWT...")
    auth_request_data = {'client_id': 'jumpauth',
                         'client_secret': config.client_secret,
                         'username': config.username,
                         'password': password,
                         'grant_type': 'password'}
    auth_response = requests.post(config.auth_url, auth_request_data)
    # TODO bail out if we couldn't get an access token
    auth_response.raise_for_status()
    # TODO bail out if there was no access token in the answer
    access_token = auth_response.json()['access_token']
    info("Access token was received.")
    verbose("Access token is:\n'{0}'".format(access_token))
    return access_token
