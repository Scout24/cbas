#!/usr/bin/env cram
# vim: set syntax=cram :

# Make a test home

  $ mkdir test-home
  $ export HOME=test-home

  $ cbas --version
  cbas version: \d+ (re)

# Test incomplete configuration

  $ cbas upload
  ERROR: Some config options are missing, active config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  [1]


# Test incomplete configuration with verbose

  $ cbas -v upload 
  Default config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  Values supplied on the command-line are:
  {'auth_host': None,
   'jump_host': None,
   'password_provider': None,
   'ssh_key_file': None,
   'username': None}
  Final aggregated config:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  ERROR: Some config options are missing, active config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  [1]



# Test unexpected config values

  $ echo "UNEXPECTED_KEY: UNEXPECTED_VALUE" > ~/.cbas
  $ cbas upload
  ERROR: The following unexpected options were detected in configuration: UNEXPECTED_KEY
  [1]

# Test unexpected config values with verbose

  $ cbas -v upload
  Default config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  Config path is: test-home/.cbas
  ERROR: The following unexpected options were detected in configuration: UNEXPECTED_KEY
  [1]

# Cleanup

  $ rm ~/.cbas

# Test loading and overriding config with file

  $ echo "ssh-key-file: from-config-file" > ~/.cbas
  $ cbas -v -k from-command-line -a url -h host dry_run
  Default config is:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: ~/.ssh/id_rsa.pub
  username: * (glob)
  ...
  
  Config path is: test-home/.cbas
  Loaded values from config file are:
  ---
  ssh_key_file: from-config-file
  ...
  
  Processed config after loading:
  ---
  auth_host: null
  jump_host: null
  password_provider: prompt
  ssh_key_file: from-config-file
  username: * (glob)
  ...
  
  Values supplied on the command-line are:
  {'auth_host': u?'url', (re)
   'jump_host': u?'host', (re)
   'password_provider': None,
   'ssh_key_file': u?'from-command-line', (re)
   'username': None}
  Final aggregated config:
  ---
  auth_host: url
  jump_host: host
  password_provider: prompt
  ssh_key_file: from-command-line
  username: * (glob)
  ...
  

