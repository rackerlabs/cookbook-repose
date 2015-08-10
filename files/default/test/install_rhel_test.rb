require 'minitest/spec'

describe_recipe 'repose::install_rhel' do
  it 'installs Repose' do
    package('repose-valve').must_be_installed
    package('repose-filter-bundle').must_be_installed
  end
end
