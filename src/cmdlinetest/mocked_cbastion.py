#!/usr/bin/env python

from bottle import Bottle, request, response, run

app = Bottle()


@app.route('/oauth/token', method='POST')
def auth_server():
    username = request.forms.get('username')
    if username == 'user_ok':
        return {'access_token': 'my-nifty-access-token'}
    elif username == 'auth_fail':
        response.status = 400
        return {'error': 'errored with HTTP 400 on request'}
    elif username == 'create_fail':
        return {'access_token': 'the-token-with-which-create-will-fail'}
    elif username == 'delete_fail':
        return {'access_token': 'the-token-with-which-delete-will-fail'}
    else:
        return {}


@app.route('/create', method='POST')
def create():
    auth_token = request.headers.get('Authorization').split()[1]
    if auth_token == 'my-nifty-access-token':
        return {'response': 'Successful creation of user.'}
    elif auth_token == 'the-token-with-which-create-will-fail':
        response.status = 403
        return {'error': 'Permission denied'}


@app.route('/delete', method='POST')
def delete():
    auth_token = request.headers.get('Authorization').split()[1]
    if auth_token == 'my-nifty-access-token':
        return {'response': 'Successful deletion of user.'}
    elif auth_token == 'the-token-with-which-delete-will-fail':
        response.status = 403
        return {'error': 'Permission denied'}

run(app, host='localhost', port=8080, debug=True, reloader=True)
