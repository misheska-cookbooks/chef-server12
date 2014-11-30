include_recipe 'chef-server12::_configure_node_dns' \
  if node['chef_server12']['write_hosts']
include_recipe 'chef-server12::_add_server_to_authorized_keys'

directory '/etc/chef' do
  recursive true
end

url = "https://#{node['chef_server12']['api_fqdn']}/organizations"\
  "/#{node['chef_server12']['organization']}"
validation_client = "#{node['chef_server12']['organization']}-validator"

file '/etc/chef/client.rb' do
  content <<-EOH
  log_level :info
  log_location STDOUT
  chef_server_url "#{url}"
  validation_client_name "#{validation_client}"
  EOH
  mode 0644
  not_if { File.exist?('/etc/chef/client.rb') }
end
