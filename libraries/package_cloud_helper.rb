module PackageCloud
  # Helper methods for parsing PackageCloud URLs
  module Helper
    def local_path_from_url(url)
      package_name = package_name_from_url(url)
      File.join(Chef::Config[:file_cache_path], package_name)
    end

    def package_name_from_url(url)
      uri_parsed = URI.parse(url)
      cgi_parsed = CGI.parse(uri_parsed.query)
      cgi_parsed['filename'].first
    end
  end
end
