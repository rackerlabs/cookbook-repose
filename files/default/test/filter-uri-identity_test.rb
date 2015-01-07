require 'minitest/spec'

describe_recipe 'repose::filter-uri-identity' do

  it 'sets up uri-identity.cfg.xml' do
    file('/etc/repose/uri-identity.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end
