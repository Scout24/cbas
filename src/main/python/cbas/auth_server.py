import requests


def obtain_access_token(config, password):
    auth_request_data = {'client_id': 'jumpauth',
                         'client_secret': config.client_secret,
                         'username': config.username,
                         'password': password,
                         'grant_type': 'password'}
    auth_response = requests.post(config.auth_url, auth_request_data)
    auth_response.raise_for_status()
    return auth_response.json()['access_token']
