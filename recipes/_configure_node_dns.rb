node_fqdn = node['chef_server12']['node_fqdn']
node_hostname = hostname_from_fqdn(node_fqdn)
node_ipaddress = node['chef_server12']['node_ipaddress']
chef_server_fqdn = node['chef_server12']['backend']['fqdn']

template '/etc/hosts' do
  source 'hosts.node.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    node_fqdn: node_fqdn,
    node_hostname: node_hostname,
    node_ipaddress: node_ipaddress,
    chef_server_fqdn: chef_server_fqdn,
    chef_server_ipaddress: node['chef_server12']['backend']['ipaddress']
  )
end
