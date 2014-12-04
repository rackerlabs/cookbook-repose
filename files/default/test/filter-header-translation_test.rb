require 'minitest/spec'

describe_recipe 'repose::filter-header-translation' do

  it 'sets up header-translation.cfg.xml' do
    file('/etc/repose/header-translation.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end
