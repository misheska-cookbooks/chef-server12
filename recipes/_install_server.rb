package_url = node['chef_server12']['url']
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
  notifies :run, 'execute[reconfigure-chef-server]', :immediately
end

execute 'reconfigure-chef-server' do
  command 'chef-server-ctl reconfigure'
  action :nothing
end

node['chef_server12']['feature'].each do |name, enabled|
  install_feature name if enabled
end
