module DNS
  # Helper methods for working with DNS
  module Helper
    def hostname_from_fqdn(fqdn)
      fqdn.split('.').first
    end
  end
end
