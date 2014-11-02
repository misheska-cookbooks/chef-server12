# chef-server12
[![wercker status](https://app.wercker.com/status/49216db211e2262832c1a7eea6b624a8/m "wercker status")](https://app.wercker.com/project/bykey/49216db211e2262832c1a7eea6b624a8)

This cookbook can be used to bootstrap a Chef Server 12 cluster with an
initial set of nodes.

# Overview

Install the Chef Development Kit, available via http://downloads.getchef.com

On Mac OS X and Linux, configure the PATH and GEM environment variables with:

    $ eval "$(chef shell-init bash)"

All cookbook-related development activities are Rake tasks:

To spin up your very own test Chef Server cluster:

    $ rake standalone:converge

Access web management UI via the username password `chefadmin` / `chefadmin`:

   $ https://192.168.33.34

The IP address is configurable with the `CHEF_SERVER_IP` environment variable.

## Prerequisites

2GB free memory for the instances:

* Chef Server - 1.5GB
* Each node managed by Chef - 512MB

Clone this repository:

    git clone https://github.com/misheska-cookbooks/chef-server12

Install the [Chef Development Kit](http://www.getchef.com/downloads/chef-dk)
for your platform.

Install the following virtualization software:

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)

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
