require 'minitest/spec'

describe_recipe 'repose::filter-http-logging' do

  it 'sets up http-logging.cfg.xml' do
    file('/etc/repose/http-logging.cfg.xml').must_exist.with(
      :owner, 'repose').and(:group, 'repose').and(:mode, '0644')
  end

end
