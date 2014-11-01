#!/bin/bash -eux

echo '==> Installing chef-solo'
curl -L https://www.opscode.com/chef/install.sh | sudo bash
echo '==> Performing Chef run'
chef-solo --json-attributes standalone.json --config ./solo.rb
