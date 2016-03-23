from cbas.log import verbose, info
import cbas.log as log
import requests

from six.moves.urllib.parse import urlparse


def get_auth_url(config):
    result = config.auth_host
    # add the scheme if none exists
    if "://" not in config.auth_host:
        result = 'https://{0}'.format(result)
    # add the endpoint if none exists
    parsed = urlparse(result)
    if not parsed.path:
        result = '{0}/oauth/token'.format(result)
    return result


def obtain_access_token(config, password):
    info("Will now attempt to obtain an JWT...")
    auth_request_data = {'client_id': 'jumpauth',
                         'username': config.username,
                         'password': password,
                         'grant_type': 'password'}
    auth_url = get_auth_url(config)
    auth_response = requests.post(auth_url, auth_request_data)

    if auth_response.status_code not in [200, 201]:
        log.info("Authentication failed: {0}".
                 format(auth_response.json().get("error")))
        auth_response.raise_for_status()
    else:
        log.info("Authentication OK!")

    # TODO bail out if there was no access token in the answer
    access_token = auth_response.json()['access_token']
    info("Access token was received.")
    verbose("Access token is:\n'{0}'".format(access_token))
    return access_token
