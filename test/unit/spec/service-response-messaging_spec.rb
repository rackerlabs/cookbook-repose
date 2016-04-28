require 'chefspec'
require_relative 'spec_helper'

describe 'repose::default' do
  before { stub_resources }

  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'no response-messaging.cfg.xml is created by default' do
    expect(chef_run).not_to render_file('/etc/repose/response-messaging.cfg.xml')
  end
end

describe 'repose::default' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['repose']['services'] = ['response-messaging']
      node.set['repose']['response_messaging']['status_codes'] = [{ 'id' => 'test_bad_input',
                                                                    'code_regex' => '4..',
                                                                    'messages'   => [
                                                                      { 'media_type' => 'application/xml',
                                                                        'content'    => '<![CDATA[
<overLimit
   xmlns="http://docs.openstack.org/compute/api/v1.1"
   code="413"
   retryAfter="%{Retry-After DATE ISO_8601}o">
 <message>OverLimit Retry...</message>
 <details>Error Details...</details>
</overLimit>
]]>' }]
}]
    end.converge(described_recipe)
  end

  it 'create response-messaging.cfg.xml with only required fields and single status & message' do
    expect(chef_run).to render_file('/etc/repose/response-messaging.cfg.xml').with_content(%r{<\?xml\s+
           version="1.0"\s+
           encoding="UTF-8"\?>\s+
       <response-messaging\s+
           xmlns="http://docs.openrepose.org/repose/response-messaging/v1.0">\s+
           <status-code\s+
               id="test_bad_input"\s+
               code-regex="4.."\s+
           >\s+
               <message\s+
                   media-type="application/xml"\s+
               >\s+
               <!\[CDATA\[\s+
       <overLimit\s+
           xmlns="http://docs.openstack.org/compute/api/v1.1"\s+
           code="413"\s+
           retryAfter="%{Retry-After\sDATE\sISO_8601}o">\s+
         <message>OverLimit\sRetry...</message>\s+
         <details>Error\sDetails...</details>\s+
       </overLimit>\s+
       \]\]>\s+
               </message>\s+
           </status-code>\s+
       </response-messaging>}x)
  end
end

describe 'repose::default' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['repose']['services'] = ['response-messaging']
      node.set['repose']['response_messaging']['status_codes'] = [{ 'id' => 'test_bad_input',
                                                                    'code_regex' => '4..',
                                                                    'overwrite'  => 'ALWAYS',
                                                                    'messages'   => [
                                                                      { 'media_type'   => 'application/xml',
                                                                        'content_type' => 'text/plain',
                                                                        'content'      => '<![CDATA[<test/>]]>' },
                                                                      { 'media_type'   => '*/*',
                                                                        'content_type' => 'application/json',
                                                                        'content'      => '{"test":"bad"}' }] },
                                                                  { 'id'         => 'test_error',
                                                                    'code_regex' => '5..',
                                                                    'overwrite'  => 'ALWAYS',
                                                                    'messages'   => [
                                                                      { 'media_type' => 'application/xml',
                                                                        'content_type' => 'text/plain',
                                                                        'content'      => '<![CDATA[<error/>]]>' },
                                                                      { 'media_type'   => '*/*',
                                                                        'content_type' => 'application/json',
                                                                        'content'      => '{"test":"error"}' }] }]
    end.converge(described_recipe)
  end

  it 'create response-messaging.cfg.xml with optional fields and multiple status & message nodes' do
    expect(chef_run).to render_file('/etc/repose/response-messaging.cfg.xml').with_content(%r{<\?xml\s+
       version="1.0"\s+
       encoding="UTF-8"\?>\s+
       <response-messaging\s+
           xmlns="http://docs.openrepose.org/repose/response-messaging/v1.0">\s+
           <status-code\s+
               id="test_bad_input"\s+
               code-regex="4.."\s+
               overwrite="ALWAYS"\s+
           >\s+
               <message\s+
                   media-type="application/xml"\s+
                   content-type="text/plain"\s+
               >\s+
               <!\[CDATA\[<test/>\]\]>\s+
               </message>\s+
               <message\s+
                   media-type="\*/\*"\s+
                   content-type="application/json"\s+
               >\s+
               \{"test":"bad"\}\s+
               </message>\s+
           </status-code>\s+
           <status-code\s+
               id="test_error"\s+
               code-regex="5.."\s+
               overwrite="ALWAYS"\s+
           >\s+
               <message\s+
                   media-type="application/xml"\s+
                   content-type="text/plain"\s+
               >\s+
               <!\[CDATA\[<error/>\]\]>\s+
               </message>\s+
               <message\s+
                   media-type="\*/\*"\s+
                   content-type="application/json"\s+
               >\s+
               \{"test":"error"\}\s+
               </message>\s+
           </status-code>\s+
       </response-messaging>}x)
  end
end
