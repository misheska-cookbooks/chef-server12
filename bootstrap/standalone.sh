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
chef-solo --json-attributes standalone.json --config ./solo.rb
