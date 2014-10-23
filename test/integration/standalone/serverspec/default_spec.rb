require 'spec_helper'

describe 'chef-server12' do
  it 'has chef-server-core installed' do
    expect(package 'chef-server-core').to be_installed
  end

  it 'passes pedant tests' do
    expect(command('chef-server-ctl test').exit_status).to eq 0
  end
end
