require 'minitest/spec'

describe_recipe 'repose::filter-header-identity' do

  it 'sets up header-identity.cfg.xml' do
    file('/etc/repose/header-identity.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end
