organization = node['chef_server12']['organization']
organization_long_name = node['chef_server12']['organization_long_name']
admin_username = node['chef_server12']['admin_username']
organization_private_key_path = \
  node['chef_server12']['organization_private_key_path']

execute 'create organization' do
  command <<-EOM.gsub(/\s+/, ' ').strip!
    chef-server-ctl org-create #{organization}
    #{organization_long_name}
    -a #{admin_username}
    > #{organization_private_key_path}
  EOM
  not_if "chef-server-ctl org-list | grep -w #{organization}"
end
