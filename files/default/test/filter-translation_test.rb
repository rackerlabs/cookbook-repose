require 'minitest/spec'

describe_recipe 'repose::filter-translation' do

  it 'sets up translation.cfg.xml' do
    file('/etc/repose/translation.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end
