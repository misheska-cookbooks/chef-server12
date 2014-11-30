case node['platform_family']
when 'rhel'
  default['chef_server12']['url'] = \
    'https://web-dl.packagecloud.io/chef/stable/packages/el/6'\
    '/chef-server-core-12.0.0-1.el6.x86_64.rpm'
  default['chef_server12']['analytics_url'] = \
    'https://web-dl.packagecloud.io/chef/stable/packages/el/6'\
    '/opscode-analytics-1.0.4-1.el6.x86_64.rpm'
when 'debian'
  default['chef_server12']['url'] = \
    'https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty'\
    '/chef-server-core_12.0.0-1_amd64.deb'
  default['chef_server12']['analytics_url'] = \
    'https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/precise'\
    '/opscode-analytics_1.0.4-1_amd64.deb'
end

# Premium features:
# chef-ha, chef-sync, opscode-analytics, opscode-manage,
# opscode-push-jobs-server, opscode-reporting
default['chef_server12']['feature']['opscode-manage'] = true
default['chef_server12']['feature']['opscode-reporting'] = true
default['chef_server12']['feature']['chef-sync'] = false
default['chef_server12']['feature']['opscode-push-jobs-server'] = false
# Premium features that aren't plugins
default['chef_server12']['analytics'] = true

# Chef Server Parameters
default['chef_server12']['api_fqdn'] = node['ipaddress']
default['chef_server12']['topology'] = 'standalone'
default['chef_server12']['write_hosts'] = false

default['chef_server12']['admin_username'] = 'chefadmin'
default['chef_server12']['admin_firstname'] = 'Chef'
default['chef_server12']['admin_lastname'] = 'Admin'
default['chef_server12']['admin_email'] = 'chef@chefadmin.com'
default['chef_server12']['admin_password'] = 'chefadmin'
default['chef_server12']['admin_private_key_path'] = '/tmp/chefadmin.pem'
default['chef_server12']['organization'] = 'default'
default['chef_server12']['organization_long_name'] = 'Default Organization'
default['chef_server12']['organization_private_key'] = \
   "#{node['chef_server12']['organization']}-validator.pem"
default['chef_server12']['organization_private_key_path'] = \
   File.join('/tmp', node['chef_server12']['organization_private_key'])
