define :install_feature do
  name = params[:name]

  execute "chef-server-ctl install #{name}" do
    not_if { ::Dir.exist?("/opt/#{name}") }
    notifies :run, "execute[#{name}-ctl reconfigure]", :immediately
  end

  execute "#{name}-ctl reconfigure" do
    notifies :run, 'execute[reconfigure-chef-server]'
    action :nothing
  end
end
