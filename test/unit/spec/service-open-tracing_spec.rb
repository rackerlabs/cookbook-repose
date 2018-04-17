# frozen_string_literal: true

require 'chefspec'
require_relative 'spec_helper'

describe 'repose::service-open-tracing' do
  before { stub_resources }

  let(:chef_run) { ChefSpec::SoloRunner.new.converge('repose::default', described_recipe) }
  let(:template) { chef_run.template('/etc/repose/open-tracing.cfg.xml') }

  it 'sends a restart notification to the service repose-valve' do
    expect(template).to notify('service[repose-valve]').to(:restart)
  end
  it 'creates a template at /etc/repose/open-tracing.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/open-tracing.cfg.xml')
  end
end

describe 'repose::service-open-tracing-default' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                           = '8.8.3.0'
      node.override['repose']['services']                          = ['open-tracing']
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has default endpoint' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint="http://localhost:12682/api/traces"})
  end

  it 'open-tracing has constant sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle="off"/>})
  end
end

describe 'repose::service-open-tracing-http-endpoint' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                           = '8.8.3.0'
      node.override['repose']['services']                          = ['open-tracing']
      node.override['repose']['open_tracing']['http']['endpoint']  = 'https://example.com/api/traces'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has set endpoint' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint="https://example.com/api/traces"})
  end

  it 'open-tracing has constant sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle="off"/>})
  end
end

describe 'repose::service-open-tracing-http-username-pass' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                           = '8.8.3.0'
      node.override['repose']['services']                          = ['open-tracing']
      node.override['repose']['open_tracing']['http']['username']  = 'reposeuser'
      node.override['repose']['open_tracing']['http']['password']  = 'reposepass'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has default endpoint' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint="http://localhost:12682/api/traces"})
  end

  it 'open-tracing has set username' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/username="reposeuser"/)
  end

  it 'open-tracing has set password' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/password="reposepass"/)
  end

  it 'open-tracing has constant sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle="off"/>})
  end
end

describe 'repose::service-open-tracing-http-token' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                        = '8.8.3.0'
      node.override['repose']['services']                       = ['open-tracing']
      node.override['repose']['open_tracing']['http']['token']  = 'reposetoken'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has default endpoint' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint="http://localhost:12682/api/traces"})
  end

  it 'open-tracing has set token' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/token="reposetoken"/)
  end

  it 'open-tracing has constant sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle="off"/>})
  end
end

describe 'repose::service-open-tracing-udp-host' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                        = '8.8.3.0'
      node.override['repose']['services']                       = ['open-tracing']
      node.override['repose']['open_tracing']['http']['token']  = 'reposetoken'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has default endpoint' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint="http://localhost:12682/api/traces"})
  end

  it 'open-tracing has set token' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/token="reposetoken"/)
  end

  it 'open-tracing has constant sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle="off"/>})
  end
end

describe 'repose::service-open-tracing-udp-port' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                         = '8.8.3.0'
      node.override['repose']['services']                        = ['open-tracing']
      node.override['repose']['open_tracing']['connection_type'] = 'udp'
      node.override['repose']['open_tracing']['udp']['port']     = '9090'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has udp host and port set' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-udp port="9090" host="localhost"/)
  end

  it 'open-tracing has constant sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle="off"/>})
  end
end

describe 'repose::service-open-tracing-constant-toggle-on' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                            = '8.8.3.0'
      node.override['repose']['services']                           = ['open-tracing']
      node.override['repose']['open_tracing']['connection_type']    = 'udp'
      node.override['repose']['open_tracing']['constant']['toggle'] = 'on'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has udp host and port set' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-udp port="5775" host="localhost"/)
  end

  it 'open-tracing has constant sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle="on"/>})
  end
end

describe 'repose::service-open-tracing-rate-limiting' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                         = '8.8.3.0'
      node.override['repose']['services']                        = ['open-tracing']
      node.override['repose']['open_tracing']['connection_type'] = 'udp'
      node.override['repose']['open_tracing']['sampling_type']   = 'rate-limiting'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has udp host and port set' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-udp port="5775" host="localhost"/)
  end

  it 'open-tracing has rate-limiting sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-rate-limiting  />})
  end
end

describe 'repose::service-open-tracing-rate-limiting-max-tps' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                         = '8.8.3.0'
      node.override['repose']['services']                        = ['open-tracing']
      node.override['repose']['open_tracing']['connection_type'] = 'udp'
      node.override['repose']['open_tracing']['sampling_type']   = 'rate-limiting'
      node.override['repose']['open_tracing']['rate_limiting']['max_traces_per_second'] = '5.5'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has udp host and port set' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-udp port="5775" host="localhost"/)
  end

  it 'open-tracing has rate-limiting sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-rate-limiting max-traces-per-second="5.5" />})
  end
end

describe 'repose::service-open-tracing-probabilistic' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                         = '8.8.3.0'
      node.override['repose']['services']                        = ['open-tracing']
      node.override['repose']['open_tracing']['connection_type'] = 'udp'
      node.override['repose']['open_tracing']['sampling_type']   = 'probabilistic'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has udp host and port set' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-udp port="5775" host="localhost"/)
  end

  it 'open-tracing has probabilistic sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-probabilistic  />})
  end
end

describe 'repose::service-open-tracing-probabilistic-probability' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.override['repose']['version']                         = '8.8.3.0'
      node.override['repose']['services']                        = ['open-tracing']
      node.override['repose']['open_tracing']['connection_type'] = 'udp'
      node.override['repose']['open_tracing']['sampling_type']   = 'probabilistic'
      node.override['repose']['open_tracing']['probabilistic']['probability'] = '0.9'
    end.converge('repose::default', 'repose::service-open-tracing')
  end

  it 'open-tracing has correct namespace for version 8' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<open-tracing xmlns="http://docs.openrepose.org/repose/open-tracing/v1.0"})
  end

  it 'open-tracing has default service name' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name="test-repose">/)
  end

  it 'open-tracing has udp host and port set' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-udp port="5775" host="localhost"/)
  end

  it 'open-tracing has probabilistic sampling algorithm' do
    expect(chef_run).to render_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-probabilistic probability="0.9" />})
  end
end
