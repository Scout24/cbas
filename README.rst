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

.. contents:: Table of Contents
   :depth: 1

About
=====

This is the command line interface to the
`*c-bastion* jump host <https://github.com/ImmobilienScout24/c-bastion>`_.
It allows you to upload an ssh-key-file and create a user on the jump-host, so
that you can log into it. It requires an initial connection to auth-server to
obtain an (open-id-connect) access token.

The basic flow is as follows::

    +-----------------+  +-----------------+  +-----------------+
    |                 |  |                 |  |                 |
    |    developer    |  |    jump host    |  |   auth server   |
    |                 |  |                 |  |                 |
    +--------+--------+  +--------+--------+  +--------+--------+
             |                    |                    |
             +----------------------------------------->
             | request token      |                    |
             <-----------------------------------------+
             | receive token      |                    |
             |                    |                    |
             +-------------------->                    |
             | upload key         +-------------------->
             |                    | validate token     |
             |                    <--------------------+
             <--------------------+                    |
             | upload OK          |                    |
             |                    |                    |
             +-------------------->                    |
             | ssh log in         |                    |
             |                    |                    |
             |                    |                    |
             |                    |                    |
             +                    +                    +

Where ``developer`` is your local machine (desktop, laptop, etc..) ``auth
server`` is the auth-server and ``jump host`` is the jump host. ``cbas`` takes
care of obtaining the token and uploading the ssh-key.

Install
=======

Use the Python standards, for example:

.. code-block:: console

    $ pip install cbas

Quickstart
==========

#. Install the software.

#. Ask one of your colleagues for the ``auth-host``, ``client-secret`` and
   ``jump-host`` parameters.

#. Then run the following to upload your key:

   .. code-block:: console

       $ cbas -a <AUTH-host> -s <CLIENT-SECRET> -h <JUMP-HOST> upload
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
      -s, --client-secret <secret>    Special client secret, ask mum.
      -a, --auth-host <host>          Auth-server host.
      -h, --jump-host <host>          Jump host to connect with.
      --version                       Print version and exit.
      --help                          Show this message and exit.

    Commands:
      delete  Delete user.
      dry_run Dry run, sanitize all config only.
      upload  Upload ssh-key and create user.

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

auth-host
  The hostname of the auth-server. E.g ``auth-server.example``. (Note that, by
  default this will use ``https://`` as scheme and ``/oauth/token`` as
  endpoint. However, explict urls, e.g.  ``http://auth-server.example`` and
  explicit endpoints e.g. ``auth-server.example/special/id/auth`` are
  tolerated.)

client-secret
  A special client secret string needed when communicating with the
  auth-server.

jump-host
  The hostname of the jump-host. E.g. ``jump-host.example``. (Note that, by
  default this will use ``https://``. However, explict urls, e.g.
  ``http://jump-host.example`` are tolerated.)

version
  Display version number and exit.

help
  Display help and exit.

Subcommands
-----------

upload
  Upload ssh-key-file and create user.

dry_run
  Sanitize and aggregate all options from config-file and command-line. Don't
  connect to anything.

delete
  Delete your user again. For example: if you uploaded the wrong ssh-key-file.

Config-File
===========

``cbas`` is equipped with a powerful configuration mechanism. All relevant
parameters that can be supplied on the command-line can also be supplied in the
config-file, for example:


.. code-block:: yaml

    username: acid_burn
    ssh-key-file: ~/.ssh/mykey_rsa.pub
    auth-host auth-server.example
    client-secret: mysupersecret
    password-provider: keyring
    jump-host: jump-host.example

Please note that, any parameters supplied on the command line will take
precedence over those supplied via the config-file. If in doubt, try using the
``--verbose`` switch.

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
