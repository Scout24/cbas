#!/usr/bin/env python

from bottle import Bottle, request, response, run

app = Bottle()


@app.route('/oauth/token', method='POST')
def auth_server():
    username = request.forms.get('username')
    if username == 'return_400':
        response.status = 400
        return {'error': 'errored with HTTP 400 on request'}
    return {}


@app.route('/create')
def create():
    pass

run(app, host='localhost', port=8080, debug=True, reloader=True)
