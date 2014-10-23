case node['platform_family']
when 'rhel'
  default['chef_server12']['url'] = \
    'https://packagecloud.io/chef/stable/download?distro=6'\
    '&filename=chef-server-core-12.0.0_rc.5-1.el5.x86_64.rpm'
when 'debian'
  default['chef_server12']['url'] = \
    'https://packagecloud.io/chef/stable/download?distro=precise'\
    '&filename=chef-server-core_12.0.0-rc.5-1_amd64.deb'
end

# Premium features
default['chef_server12']['feature']['opscode-manage'] = true
default['chef_server12']['feature']['opscode-reporting'] = false
default['chef_server12']['feature']['chef-sync'] = false
default['chef_server12']['feature']['opscode-push-jobs-server'] = false

# Chef Server Parameters
default['chef-server12']['api_fqdn'] = node['ipaddress']
default['chef-server12']['topology'] = 'standalone'

default['chef_server12']['admin_username'] = 'chefadmin'
default['chef_server12']['admin_firstname'] = 'Chef'
default['chef_server12']['admin_lastname'] = 'Admin'
default['chef_server12']['admin_email'] = 'chef@chefadmin.com'
default['chef_server12']['admin_password'] = 'chefadmin'
default['chef_server12']['admin_private_key_path'] = '/tmp/chefadmin.pem'
default['chef_server12']['organization'] = 'default'
default['chef_server12']['organization_long_name'] = 'Default Organization'
default['chef_server12']['organization_private_key_path'] = '/tmp/validator.pem'
