require 'spec_helper'

describe DNS::Helper do
  let(:dns_helper) { Object.new.extend(DNS::Helper) }

  before(:each) do
    @fqdn = 'node1.vagrantup.com'
  end

  describe 'hostname_from_fqdn' do
    it 'extracts host from fqdn' do
      expect(dns_helper.hostname_from_fqdn(@fqdn)).to match \
             'node1'
    end
  end
end
