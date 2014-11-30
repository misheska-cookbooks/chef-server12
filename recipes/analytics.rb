include_recipe 'chef-server12::_add_server_to_authorized_keys'
include_recipe 'chef-server12::_configure_analytics_dns'

analytics_fqdn = node['chef_server12']['backend']['analytics_fqdn']

directory '/etc/opscode-analytics'

template '/etc/opscode-analytics/opscode-analytics.rb' do
  source 'opscode-analytics.rb.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    analytics_fqdn: analytics_fqdn
  )
end

package_url = node['chef_server12']['analytics_url']
package_name = package_name_from_url(package_url)
package_local_path = local_path_from_url(package_url)

remote_file package_local_path do
  source package_url
end

package package_name do
  source package_local_path
  provider case node['platform_family']
           when 'rhel' then Chef::Provider::Package::Rpm
           when 'debian' then Chef::Provider::Package::Dpkg
           end
end
