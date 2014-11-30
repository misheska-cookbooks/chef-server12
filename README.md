# chef-server12
[![wercker status](https://app.wercker.com/status/49216db211e2262832c1a7eea6b624a8/m "wercker status")](https://app.wercker.com/project/bykey/49216db211e2262832c1a7eea6b624a8)

This cookbook can be used to bootstrap a Chef Server 12 cluster with an
initial set of nodes.

# Overview

Install the Chef Development Kit, available via http://downloads.getchef.com

On Mac OS X and Linux, configure the PATH and GEM environment variables with:

    $ eval "$(chef shell-init bash)"

All cookbook-related development activities are Rake tasks:

    rake complete                       # Run _all_ the tests
    rake foodcritic                     # Lint Chef cookbooks
    rake kitchen:all                    # Run all test instances
    rake kitchen:analytics-centos65     # Run analytics-centos65 test instance
    rake kitchen:analytics-ubuntu1404   # Run analytics-ubuntu1404 test instance
    rake kitchen:node1-centos65         # Run node1-centos65 test instance
    rake kitchen:node1-ubuntu1404       # Run node1-ubuntu1404 test instance
    rake kitchen:node2-centos65         # Run node2-centos65 test instance
    rake kitchen:node2-ubuntu1404       # Run node2-ubuntu1404 test instance
    rake kitchen:standalone-centos65    # Run standalone-centos65 test instance
    rake kitchen:standalone-ubuntu1404  # Run standalone-ubuntu1404 test instance
    rake rubocop                        # Run RuboCop
    rake rubocop:auto_correct           # Auto-correct RuboCop offenses
    rake spec                           # Run RSpec code examples
    rake standalone:converge[platform]  # converge standalone cluster
    rake standalone:create[platform]    # create standalone cluster
    rake standalone:destroy[platform]   # destroy standalone cluster
    rake standalone:login[platform]     # login to standalone server
    rake test:quick                     # Run all the quick tests

To spin up your very own test Chef Server cluster:

    $ rake standalone:converge

Access web management UI via the username password `chefadmin` / `chefadmin`:

   $ https://192.168.33.34

The IP address is configurable with the `CHEF_SERVER_IP` environment variable.

## Prerequisites

3.5GB free memory for the instances:

* Chef Server - 1.5GB
* Analytics Server - 1.5GB
* Each node managed by Chef - 512MB

Clone this repository:

    git clone https://github.com/misheska-cookbooks/chef-server12

Install the [Chef Development Kit](http://www.getchef.com/downloads/chef-dk)
for your platform.

Install the following virtualization software:

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)

Attributes
==========

The attributes used by this cookbook are in the `node['chef_server12']`
namespace:

Attribute              | Description |Type | Default
-----------------------|-------------|-----|--------
admin_username         | Chef admin username | String | 'chefadmin'
admin_firstname        | Chef admin first name | String | 'Chef'
admin_lastname         | Chef admin last name | String | 'Admin'
admin_email            | Chef admin e-mail | String | 'chefadmin@localhost'
admin_private_key_path | Local path where a copy of private key for the admin user should be stored | '/tmp/chefadmin.pem'
analytics              | Install Chef Analytics | Boolean | true
api_fqdn               | Fully qualified domain name that you want to use for accessing the Web UI and API. | String | node['api_fqdn']
backend.analytics_fqdn | Fully qualified domain name of the  Chef Analytics server machine | String | node['analytics_fqdn']
backend.analytics_ipaddress | (Optional) IP address of the Chef Analytics server machine | String | node['analytics_ipaddress']
backend.fqdn           | Fully qualified domain name of the Chef Server machine itself. | String | node['api_fqdn']
backend.ipaddress      | (Optional) IP address of the Chef Server machine | String | node['ipaddress']
feature                | List of premium features to install.  Possible values are `opscode-manage`, `opscode-reporting`, `chef-sync`, and `opscode-push-jobs-server`. | Boolean | false
nodes                  | List of `fqdn: ipaddress` pair values of nodes to register.  `ipaddress` is optional | Hash | Hash.new
configuration          | Configuration values to pass down to the underlying server config file (i.e. `/etc/chef-server/chef-server.rb`). | Hash | Hash.new
org_name               | Organization name to be created | String | 'default'
org_long_name          | Descriptive string for the organization | String | 'Default Organization'
org_private_key        | Name for the organization validation key | String | #{node['chef_server12']['organization']}-validator.pem
org_private_key_path   | Local path where a copy of organization validation key should be stored | '/tmp/default-validator.pem'
topology               | Installation cluster topology.  Possible values are `standalone`, `tiered` or `ha`. | String | 'standalone'
version                | Chef Server version to install. This value is ignored if `package_file` is set. | String | :latest
write_hosts            | Generate `/etc/hosts` file on nodes with values from `backend` and `nodes` attributes. | Boolean | false

Recipes
=======

Here's the recipes in the cookbook and how to use them in your environment.

standalone
----------
Installs a Chef Server cluster using the `standalone` topology and registers
the specified initial set of nodes.

node
----
Initializes a node, allowing root access by the Chef Server temporarily to
bootstrap the node with Chef.

Install Methods
===============

## Bootstrapping with chef-solo

In production, `chef-solo` can be used to run a Chef cookbook when there is no
Chef Server.  `chef-solo` is included with the Chef Client install, available
via:

    curl -L https://www.opscode.com/chef/install.sh | sudo bash

In order to use `chef-solo` to run this cookbook, create a `.json` file with
the attribute values reflecting the intended setup.  You can find an example
in `bootstrap/standalone.json`:

    {
      "chef_server12": {
        "topology": "standalone",
        "api_fqdn": "standalone.vagrantup.com",
        "write_hosts": true,
        "backend": {
          "fqdn": "standalone.vagrantup.com",
          "ipaddress": "192.168.33.34"
        }
      },
      "run_list": [
        "recipe[chef-server12::standalone]"
      ]
    }

Also create a `solo.rb` file with the full path to the root `cookbooks/`
directory where this cookbook is stored.  Unfortunately this is the one
necessary value that cannot be passed to `chef-solo` as a command line
parameter.  Here is an example `solo.rb` file:

    cookbook_path '/var/chef-solo/cookbooks'

Here's the command like you would use to use `chef-solo` to perform
a Chef run:

    $ sudo chef-solo --json-attributes standalone.json --config ./solo.rb

The following script, which can be found in `bootstrap/standalone.sh`
shows how you can dynamically generate a `solo.rb` file along with the
full `chef-solo` command line for running this cookbook to bootstrap a
Chef Server setup:

    #!/bin/bash -eux

    abspath()
    {
      cd "$(dirname "$1")"
      printf "%s/%s\n" "$(pwd)" "$(basename "$1")"
    }

    generate_solo_rb()
    {
      cat > solo.rb <<_EOF_
    cookbook_path "$(abspath '../..')"
    _EOF_
    }

    echo '==> Installing chef-solo'
    curl -L https://www.opscode.com/chef/install.sh | sudo bash

    if [ ! -f "solo.rb" ] ; then
      echo '==> Generating solo.rb'
      generate_solo_rb
    fi

    echo '==> Performing Chef run'
    sudo chef-solo --json-attributes standalone.json --config ./solo.rb

## Demo with Test Kitchen

You can also use Test Kitchen to quickly generate a development Chef Server
setup.  Refer to the Overview section.
