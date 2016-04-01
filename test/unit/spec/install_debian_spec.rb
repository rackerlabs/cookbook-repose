require 'chefspec'
require_relative 'spec_helper'

describe 'repose::install_debian' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge('repose::default', described_recipe) }

  it 'includes the recipe apt::default' do
    expect(chef_run).to include_recipe('apt::default')
  end

  it 'install the apt repository' do
    expect(chef_run).to add_apt_repository('openrepose')
  end

  packages = %w(repose-valve repose-filter-bundle repose-extensions-filter-bundle)
  packages.each do |p|
    it 'installs package #{p}' do
      expect(chef_run).to install_package(p)
    end
  end
end
