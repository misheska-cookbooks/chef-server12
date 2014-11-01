# Create root's .ssh directory
directory '/root/.ssh' do
  action :create
  owner 'root'
  group 'root'
  mode '0700'
end

# Create a temporary SSH key for pushing files to the front-end machines
cookbook_file '/root/.ssh/id_rsa' do
  source 'id_rsa'
  owner 'root'
  group 'root'
  mode '0600'
end
