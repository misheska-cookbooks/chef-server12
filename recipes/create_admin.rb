admin_username = node['chef_server12']['admin_username']
admin_firstname = node['chef_server12']['admin_firstname']
admin_lastname = node['chef_server12']['admin_lastname']
admin_email = node['chef_server12']['admin_email']
admin_password = node['chef_server12']['admin_password']
admin_private_key_path = node['chef_server12']['admin_private_key_path']

execute 'create admin' do
  command <<-EOM.gsub(/\s+/, ' ').strip!
    chef-server-ctl user-create #{admin_username}
    #{admin_firstname}
    #{admin_lastname}
    #{admin_email}
    #{admin_password}
    > #{admin_private_key_path}
  EOM
  not_if "chef-server-ctl user-list | grep -w #{admin_username}"
end
