require 'chefspec'
require_relative 'spec_helper'

describe 'repose::install' do
  context 'rhel' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.0').converge('repose::default', described_recipe) }
    it 'includes the recipe repose::install_rhel' do
      expect(chef_run).to include_recipe('repose::install_rhel')
    end
  end

  context 'debian' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge('repose::default', described_recipe) }
    it 'includes the recipe repose::install_debian' do
      expect(chef_run).to include_recipe('repose::install_debian')
    end
  end
end
