validator_pem_path = \
  File.join('/etc/chef', node['chef_server12']['organization_private_key'])
url = "https://#{node['chef_server12']['api_fqdn']}/organizations"\
      "/#{node['chef_server12']['organization']}"

if node['chef_server12'].attribute?('nodes')
  node['chef_server12']['nodes'].each do |_node_fqdn, node_ip|
    # copy validator.pem to node
    execute "scp -i /root/.ssh/id_rsa -o StrictHostKeyChecking=no \
      #{node['chef_server12']['organization_private_key_path']} \
      root@#{node_ip}:#{validator_pem_path}"

    # register the node and a client
    execute "ssh -t -t -i /root/.ssh/id_rsa -o StrictHostKeyChecking=no \
      root@#{node_ip} 'chef-client \
      --server #{url} --validation_key #{validator_pem_path}'"
  end
end
