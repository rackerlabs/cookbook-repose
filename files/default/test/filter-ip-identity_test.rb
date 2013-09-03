require 'minitest/spec'

describe_recipe 'repose::filter-ip-identity' do

  it 'sets up ip-identity.cfg.xml' do
    file('/etc/repose/ip-identity.cfg.xml').must_exist.with(
      :owner, 'repose').and(:group, 'repose').and(:mode, '0644')
  end

end
