# frozen_string_literal: true

case node['platform_family']
when 'rhel'
  default['repose']['owner'] = 'repose'
  default['repose']['group'] = 'repose'
  default['repose']['repo']['baseurl'] = 'http://repo.openrepose.org/rhel'
  default['repose']['repo']['gpgkey'] = 'http://repo.openrepose.org/rhel/RPM_GPG_KEY-openrepose'
  default['repose']['repo']['gpgcheck'] = false # the openrepose repo doesn't sign packages
  default['repose']['repo']['enabled'] = true
  default['repose']['repo']['managed'] = true
  default['repose']['install_opts'] = ''
when 'debian'
  default['repose']['owner'] = 'root'
  default['repose']['group'] = 'root'
  default['repose']['repo']['baseurl'] = 'http://repo.openrepose.org/debian'
  default['repose']['repo']['gpgkey'] = 'http://repo.openrepose.org/debian/pubkey.gpg'
  default['repose']['repo']['managed'] = true
  default['repose']['install_opts'] = '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes'
end

default['repose']['version'] = '8.8.3.0'
default['repose']['loglevel'] = 'WARN'
default['repose']['cluster_ids'] = ['repose']
default['repose']['rewrite_host_header'] = true
default['repose']['node_id'] = 'repose_node1'
default['repose']['port'] = 8080
default['repose']['ssl_port'] = 8443
default['repose']['shutdown_port'] = 8188
# container.cfg.xml settings
default['repose']['content_body_read_limit'] = nil
default['repose']['connection_timeout'] = 30000
default['repose']['read_timeout'] = 30000
default['repose']['client_request_logging'] = nil
default['repose']['proxy_thread_pool'] = nil
default['repose']['deploy_auto_clean'] = true
default['repose']['filter_check_interval'] = 60000

default['repose']['config_directory'] = '/etc/repose'
default['repose']['log_path'] = '/var/log/repose'
default['repose']['pid_file'] = '/var/run/repose-valve.pid'
default['repose']['user'] = 'repose'
default['repose']['java_opts'] = ''
default['repose']['loggers'] = []
default['repose']['appenders'] = []

default['repose']['peer_search_enabled'] = false
default['repose']['peer_search_query'] = "chef_environment:#{node.chef_environment} AND repose_cluster_ids:*"

default['repose']['peers'] = [
  { 'cluster_id' => 'repose',
    'id' => 'repose_node1',
    'hostname' => 'localhost',
    'port' => 8080 }
]

default['repose']['filters'] = []
default['repose']['services'] = []

default['repose']['endpoints'] = [
  { 'cluster_id' => 'repose',
    'id' => 'open_repose',
    'protocol' => 'http',
    'hostname' => 'openrepose.org',
    'port' => 80,
    'root_path' => '/',
    'default' => true }
]

default['repose']['add_header']['cluster_id'] = ['all']
default['repose']['add_header']['request_headers'] = []
default['repose']['add_header']['response_headers'] = []

default['repose']['url_extractor_to_header']['cluster_id'] = ['all']
default['repose']['url_extractor_to_header']['extractor_headers'] = []

default['repose']['dist_datastore']['cluster_id'] = ['all']
default['repose']['dist_datastore']['allow_all'] = false
default['repose']['dist_datastore']['allowed_hosts'] = ['127.0.0.1']
default['repose']['dist_datastore']['port'] = 8081

default['repose']['response_messaging']['cluster_id'] = ['all']
default['repose']['response_messaging']['status_codes'] = []

default['repose']['slf4j_http_logging']['cluster_id'] = ['all']
default['repose']['slf4j_http_logging']['id'] = 'http'
default['repose']['slf4j_http_logging']['format'] = 'Remote IP=%a Local IP=%A Response Size(bytes)=%b Remote Host=%h Request Method=%m Server Port=%p Query String=%q Time Request Received=%t Status=%s Remote User=%u Rate Limit Group: %<X-PP-Groups>i URL Path Requested=%U X-Forwarded-For=%<X-Forwarded-For>i X-REAL-IP=%<X-Real-IP>i'

# default for merge_header is empty (no-op)
default['repose']['merge_header']['cluster_id'] = ['all']

# default for cors is to allow all methods, all origins
default['repose']['cors']['cluster_id'] = ['all']
default['repose']['cors']['allowed_origins'] = [
  { 'is_regex' => true,
    'value'    => '.*' }
]

default['repose']['header_translation']['cluster_id'] = ['all']
default['repose']['header_translation']['headers'] = [
  { 'original_name' => 'Content-Type',
    'new_name' => 'rax-content-type' },
  { 'original_name' => 'Content-Length',
    'new_name' => 'rax-content-length not-rax-content-length something-else',
    'remove_original' => true }
]

default['repose']['derp']['cluster_id'] = ['all']

default['repose']['content_type_stripper']['cluster_id'] = ['all']

default['repose']['header_normalization']['cluster_id'] = ['all']
default['repose']['header_normalization']['whitelist'] = [
  { 'id' => 'credentials',
    'uri_regex' => '/servers/(.*)',
    'headers'   => ['X-Auth-Key', 'X-Auth-User'] },
  { 'id' => 'modification',
    'uri_regex' => '/resource/(.*)',
    'http_methods' => 'PUT POST',
    'headers'   => ['X-Modify'] }
]
default['repose']['header_normalization']['blacklist'] = [
  { 'id' => 'rate-limit-headers',
    'headers'   => ['X-PP-User', 'X-PP-Groups'] }
]

default['repose']['header_identity']['cluster_id'] = ['all']
default['repose']['header_identity']['headers'] = [
  { 'id' => 'X-Auth-Token',
    'quality' => 0.95 },
  { 'id' => 'X-Forwarded-For',
    'quality' => 0.5 }
]

default['repose']['ip_identity']['cluster_id'] = ['all']
default['repose']['ip_identity']['quality'] = 0.2
default['repose']['ip_identity']['white_list_quality'] = 1.0
default['repose']['ip_identity']['white_list_ip_addresses'] = ['127.0.0.1']

default['repose']['keystone_v2']['cluster_id'] = ['all']
default['repose']['keystone_v2']['username_admin'] = 'admin'
default['repose']['keystone_v2']['password_admin'] = 'password'
default['repose']['keystone_v2']['pool'] = nil
default['repose']['keystone_v2']['groups_in_header'] = nil
default['repose']['keystone_v2']['roles_in_header'] = nil
default['repose']['keystone_v2']['catalog_in_header'] = nil
default['repose']['keystone_v2']['uri'] = 'https://identity.api.rackspacecloud.com/v2.0'
default['repose']['keystone_v2']['delegating_quality'] = nil
default['repose']['keystone_v2']['white_list'] = nil
default['repose']['keystone_v2']['cache'] = nil
default['repose']['keystone_v2']['tenant_handling'] = nil
default['repose']['keystone_v2']['require_service_endpoint'] = nil
default['repose']['keystone_v2']['pre_authorized_roles'] = nil

default['repose']['client_auth']['cluster_id'] = ['all']
default['repose']['client_auth']['auth_provider'] = 'RACKSPACE'
default['repose']['client_auth']['username_admin'] = 'admin'
default['repose']['client_auth']['password_admin'] = 'password'
default['repose']['client_auth']['tenant_id'] = 'tenant-id'
default['repose']['client_auth']['auth_uri'] = 'https://auth.api.rackspacecloud.com/v1.1/auth'
default['repose']['client_auth']['mapping_regex'] = ['.*/v1/([-|\w]+)/?.*']
default['repose']['client_auth']['mapping_type'] = 'CLOUD'
default['repose']['client_auth']['delegable'] = false
default['repose']['client_auth']['tenanted'] = true
default['repose']['client_auth']['request_groups'] = true
default['repose']['client_auth']['token_cache_timeout'] = 600000
default['repose']['client_auth']['group_cache_timeout'] = 600000
default['repose']['client_auth']['service_admin_roles'] = []
default['repose']['client_auth']['ignore_tenant_roles'] = []
default['repose']['client_auth']['endpoints_in_header'] = false
default['repose']['client_auth']['white_list'] = false
default['repose']['client_auth']['uri_regex'] = nil

default['repose']['client_authorization']['cluster_id'] = 'all'
default['repose']['client_authorization']['username_admin'] = 'admin'
default['repose']['client_authorization']['password_admin'] = 'password'
default['repose']['client_authorization']['auth_uri'] = 'https://auth.api.rackspacecloud.com/v1.1/auth'
default['repose']['client_authorization']['tenant_id_admin'] = nil
default['repose']['client_authorization']['endpoint_list_ttl'] = 300
default['repose']['client_authorization']['connection_pool_id'] = nil
default['repose']['client_authorization']['service_endpoint'] = 'https://exampleservice.api.rackspacecloud.com/v1.0'
default['repose']['client_authorization']['service_region'] = nil
default['repose']['client_authorization']['service_name'] = nil
default['repose']['client_authorization']['service_type'] = nil
default['repose']['client_authorization']['ignore_tenant_roles'] = []
default['repose']['client_authorization']['roles'] = []
default['repose']['client_authorization']['delegating_quality'] = nil

default['repose']['rate_limiting']['cluster_id'] = ['all']
default['repose']['rate_limiting']['datastore'] = nil
default['repose']['rate_limiting']['datastore_warn_limit'] = nil
default['repose']['rate_limiting']['overlimit_429_responsecode'] = nil
default['repose']['rate_limiting']['use_capture_groups'] = nil
default['repose']['rate_limiting']['uri_regex'] = '/limits'
default['repose']['rate_limiting']['global_limits'] = []
default['repose']['rate_limiting']['include_absolute_limits'] = false
default['repose']['rate_limiting']['limit_groups'] = [
  { 'id' => 'limited',
    'groups' => 'limited',
    'default' => true,
    'limits' => [
      { 'id' => 'all',
        'uri' => '*',
        'uri_regex' => '/.*',
        'http_methods' => 'POST PUT GET DELETE',
        'unit' => 'MINUTE',
        'value' => 10 }
    ] },
  { 'id' => 'unlimited',
    'groups' => 'unlimited',
    'default' => false,
    'limits' => [] }
]

default['repose']['http_connection_pool']['cluster_id'] = ['all']
default['repose']['http_connection_pool']['chunked_encoding'] = true
default['repose']['http_connection_pool']['max_total'] = 400
default['repose']['http_connection_pool']['max_per_route'] = 200
default['repose']['http_connection_pool']['socket_timeout'] = 30000
default['repose']['http_connection_pool']['connection_timeout'] = 30000
default['repose']['http_connection_pool']['socket_buffer_size'] = 8192
default['repose']['http_connection_pool']['connection_max_line_length'] = 8192
default['repose']['http_connection_pool']['connection_max_header_count'] = 100
default['repose']['http_connection_pool']['connection_max_status_line_garbage'] = 100
default['repose']['http_connection_pool']['tcp_nodelay'] = true
default['repose']['http_connection_pool']['keepalive_timeout'] = 0

default['repose']['translation']['cluster_id'] = ['all']
default['repose']['translation']['allow_doctype_decl'] = false
default['repose']['translation']['request_translations'] = []
default['repose']['translation']['response_translations'] = []

default['repose']['rackspace_auth_user']['cluster_id'] = ['all']
default['repose']['rackspace_auth_user']['v1_1']['enabled'] = true
default['repose']['rackspace_auth_user']['v1_1']['read_limit'] = 4096
default['repose']['rackspace_auth_user']['v1_1']['group'] = 'Pre_Auth'
default['repose']['rackspace_auth_user']['v1_1']['quality'] = 0.6
default['repose']['rackspace_auth_user']['v2_0']['enabled'] = true
default['repose']['rackspace_auth_user']['v2_0']['read_limit'] = 4096
default['repose']['rackspace_auth_user']['v2_0']['group'] = 'Pre_Auth'
default['repose']['rackspace_auth_user']['v2_0']['quality'] = 0.6

default['repose']['uri_identity']['cluster_id'] = ['all']
default['repose']['uri_identity']['mappings'] = [
  '.*/servers/(\w*)/.*',
  '.*/servers/(\w*)/.*'
]
default['repose']['uri_identity']['group'] = 'User_Standard'
default['repose']['uri_identity']['quality'] = 0.5

default['repose']['uri_stripper']['cluster_id'] = ['all']
default['repose']['uri_stripper']['rewrite_location'] = true
default['repose']['uri_stripper']['token_index'] = 1

default['repose']['add_header']['cluster_id'] = ['all']
default['repose']['add_header']['requests'] = []
default['repose']['add_header']['responses'] = []

default['repose']['api_validator']['cluster_id'] = ['all']
default['repose']['api_validator']['multi_role_match'] = nil
default['repose']['api_validator']['wadl'] = nil
default['repose']['api_validator']['dot_output'] = '/tmp/default.out'
default['repose']['api_validator']['enable_rax_roles'] = nil
default['repose']['api_validator']['enable_api_coverage'] = nil
default['repose']['api_validator']['check_well_formed'] = nil
default['repose']['api_validator']['check_grammars'] = nil
default['repose']['api_validator']['check_elements'] = nil
default['repose']['api_validator']['check_plain_params'] = nil
default['repose']['api_validator']['do_xsd_grammar_transform'] = nil
default['repose']['api_validator']['enable_pre_process_extension'] = nil
default['repose']['api_validator']['remove_dups'] = nil
default['repose']['api_validator']['xpath_version'] = nil
default['repose']['api_validator']['xsl_engine'] = nil
default['repose']['api_validator']['xsd_engine'] = nil
default['repose']['api_validator']['mask_rax_roles_403'] = nil
default['repose']['api_validator']['join_xpath_checks'] = nil
default['repose']['api_validator']['enable_ignore_xsd_extension'] = nil
default['repose']['api_validator']['validator_name'] = nil
default['repose']['api_validator']['validate_checker'] = nil
default['repose']['api_validator']['check_headers'] = nil

default['repose']['ip_user']['cluster_id'] = ['all']
default['repose']['ip_user']['user_header_name'] = 'X-PP-User'
default['repose']['ip_user']['user_header_quality'] = '0.4'
default['repose']['ip_user']['group_header_name'] = 'X-PP-Groups'
default['repose']['ip_user']['group_header_quality'] = '0.4'
default['repose']['ip_user']['groups'] = [
  { 'group_name' => 'match-all',
    'cidrips' => ['0.0.0.0/0'] },
  { 'group_name' => 'rfc1918',
    'cidrips' => ['192.168.0.0/16', '172.16.0.0/12', '10.0.0.0/8'] }
]

default['repose']['open_tracing']['cluster_id'] = ['all']
default['repose']['open_tracing']['service_name'] = 'test-repose'
default['repose']['open_tracing']['connection_type'] = 'http'
default['repose']['open_tracing']['http']['endpoint'] = 'http://localhost:12682/api/traces'
default['repose']['open_tracing']['udp']['host'] = 'localhost'
default['repose']['open_tracing']['udp']['port'] = 5775
default['repose']['open_tracing']['sampling_type'] = 'constant'
default['repose']['open_tracing']['constant']['toggle'] = 'off'
default['repose']['open_tracing']['probabilistic']['probability'] = nil
default['repose']['open_tracing']['rate_limiting']['max_traces_per_second'] = nil
default['repose']['open_tracing']['http']['username'] = nil
default['repose']['open_tracing']['http']['password'] = nil
default['repose']['open_tracing']['http']['token'] = nil
