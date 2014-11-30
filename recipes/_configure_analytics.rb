if node['chef_server12']['analytics']
  execute "scp -i /root/.ssh/id_rsa -o StrictHostKeyChecking=no \
    -r /etc/opscode-analytics \
    root@#{node['chef_server12']['backend']['analytics_ipaddress']}:/etc"

  execute "ssh -t -t -i /root/.ssh/ida_rsa -o StrictHostKeyChecking=no \
    root@#{node['chef_server12']['backend']['analytics_ipaddress']} \
    'opscode-analytics-ctl preflight-check'"

  execute "ssh -t -t -i /root/.ssh/ida_rsa -o StrictHostKeyChecking=no \
    root@#{node['chef_server12']['backend']['analytics_ipaddress']} \
    'opscode-analytics-ctl reconfigure'"
end
