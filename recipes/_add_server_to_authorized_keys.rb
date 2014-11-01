# This recipe sets up a temporary ssh key so that the Chef Server can push
# its configs into /etc/opscode.  These configs are generated on the
# Chef Server and are unique to each host.
# Create root's .ssh directory
directory '/root/.ssh' do
  action :create
  owner 'root'
  group 'root'
  mode '0700'
end

cookbook_file '/root/.ssh/authorized_keys' do
  action :create
  owner 'root'
  group 'root'
  mode '0600'
  source 'id_rsa.pub'
end
