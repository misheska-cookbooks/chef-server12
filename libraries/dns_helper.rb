module DNS
  # Helper methods for working with DNS
  module Helper
    def hostname_from_fqdn(fqdn)
      fqdn.split('.').first
    end
  end
end

# include helper methods
::Chef::Recipe.send(:include, DNS::Helper)
