require 'minitest/spec'

describe_recipe 'repose::filter-connection-pool' do

  it 'sets up http-connection-pool.cfg.xml' do
    file('/etc/repose/http-connection-pool.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end
