import requests


def obtain_access_token(auth_url, client_secret, username, password):
    auth_request_data = {'client_id': 'jumpauth',
                         'client_secret': client_secret,
                         'username': username,
                         'password': password,
                         'grant_type': 'password'}
    auth_response = requests.post(auth_url, auth_request_data)
    auth_response.raise_for_status()
    return auth_response.json()['access_token']
