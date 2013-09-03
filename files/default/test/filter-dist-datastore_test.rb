require 'minitest/spec'

describe_recipe 'repose::filter-dist-datastore' do

  it 'sets up dist-datastore.cfg.xml' do
    file('/etc/repose/dist-datastore.cfg.xml').must_exist.with(
      :owner, 'repose').and(:group, 'repose').and(:mode, '0644')
  end

end
