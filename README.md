# chef-server12
[![wercker status](https://app.wercker.com/status/49216db211e2262832c1a7eea6b624a8/m "wercker status")](https://app.wercker.com/project/bykey/49216db211e2262832c1a7eea6b624a8)

This cookbook configures a system to be a Chef Server.

# Overview

Install the Chef Development Kit, available via http://downloads.getchef.com

On Mac OS X and Linux, configure the PATH and GEM environment variables with:

    $ eval "$(chef shell-init bash)"

All cookbook-related development activities are Rake tasks:

To spin up your very own Chef Server cluster:

    $ rake kitchen:standalone:converge

Access web management UI via the username password `chefadmin` / `chefadmin`:

   $ https://192.168.33.34

IP address is configurable with the `CHEF_SERVER_IP` environment variable.

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
