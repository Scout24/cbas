==============================================
cbas - command line interface to the c-bastion
==============================================

.. image:: https://travis-ci.org/ImmobilienScout24/cbas.png?branch=master
   :alt: Travis build status image
   :target: https://travis-ci.org/ImmobilienScout24/cbas

.. image:: https://coveralls.io/repos/github/ImmobilienScout24/cbas/badge.svg?branch=master
    :alt: Coverage status
    :target: https://coveralls.io/github/ImmobilienScout24/cbas?branch=master

.. image:: https://img.shields.io/pypi/v/cbas.svg
   :alt: Version
   :target: https://pypi.python.org/pypi/cbas

About
=====

This is the command line interface to the
`*c-bastion* jump host <https://github.com/ImmobilienScout24/c-bastion>`_.
It allows you to upload and ssh-key-file and create a user on the jump-host, so
that you can log into it. It requires an initial connection to auth-server to
obtain an (open-id-connect) access token.

The basic flow is as follows::

     +-----------+   +-----------+   +-----------+
     |           |   |           |   |           |
     | developer |   |   auth    |   |   jump    |
     |           |   |           |   |           |
     +-----------+   +-----------+   +-----------+
           |               |               |
           |               |               |
           +--------------->               |
           | request token |               |
           |               |               |
           <---------------+               |
           | receive token |               |
           |               |               |
           +------------------------------->
           | upload ssh-key|and create user|
           |               |               |
           |               |               |
           +------------------------------->
           | ssh login     |               |
           |               |               |
           |               |               |
           +               +               +

Where ``developer`` is your local machine (desktop, laptop, etc..) ``auth`` is
the auth-server and ``jump`` is the jump host. ``cbas`` takes care of obtaining
the token and uploading the ssh-key.

Install
=======

Use the Python standards, for example:

.. code-block:: console

    $ pip install cbas

Quickstart
==========

#. Install the software.

#. Ask one of your colleagues for the ``auth-url``, ``client-secret`` and
   ``jump-host`` parameters.

#. Then run the following to upload your key:

   .. code-block:: console

       $ cbas -a <AUTH-URL> -s <CLIENT-SECRET> -h <JUMP-HOST> upload
       ...

#. Then you *should* be able to login, using:

   .. code-block:: console

       $ ssh <JUMP-HOST>
       ...


Usage
=====

.. code-block:: console

    $ cbas --help
    Usage: cbas [OPTIONS] COMMAND [ARGS]...

    Options:
      -v, --verbose                   Activate verbose mode.
      -c, --config <config_path>      Path to config file. Default: '~/.cbas'.
      -u, --username <username>       Username. Default: the logged in user.
      -k, --ssh-key-file <key-file>   SSH Identity to use. Default:
                                      '~/.ssh/id_rsa.pub'.
      -p, --password-provider <provider>
                                      Password provider. Default: 'prompt'.
      -a, --auth-url <auth_url>       Auth-server URL.
      -s, --client-secret <secret>    Special client secret, ask mum.
      -h, --jump-host <host>          Jump host to connect with.
      --version                       Print version and exit.
      --help                          Show this message and exit.

    Commands:
      delete  Delete user.
      upload  Upload ssh-key and create user

Options
-------

verbose
  This switch activates verbose output, useful in case you are debugging

config
  The path to the config file. Note, since we are using the
  `yamlreader <https://pypi.python.org/pypi/yamlreader>`_ package, this could
  also be a directory with multiple config files. Also, the config is in YAML
  syntax, see below.

username
  The username when communicating with the auth-server. Note that the
  returned token contains the authenticated username which is subsequently
  sent to the jump-host. Thus you will not be able to create arbitrary users
  on the jump-host

ssh-key-file
  Path to the *public* ssh-key-file. This will be uploaded to the jump-host.

password-provider
  Where to get the password from. Valid values are ``prompt`` and ``keyring``
  (and ``testing``). ``prompt`` will always ask for a password, whereas
  ``keyring`` will ask exactly once and then store the password in the system
  keyring.

auth-url
  The URL to access the auth-server and obtain the token. E.g.
  ``https://auth-server.example/oauth/token``. (Note that this *includes* the
  protocol.

client-secret
  A special client secret string needed when communicating with the
  auth-server.

jump-host
  The hostname of the jump-host. E.g. ``jump-host.example``. (Note that this
  *excludes* the protocol.)

version
  Display verion number and exit.

help
  Display help and exit.

Subcommands
-----------

upload
  Upload ssh-key-file and create user.

delete
  Delete your user again. For example: if you uploaded the wrong ssh-key-file.

License
=======

Copyright 2016 Immobilien Scout GmbH

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
