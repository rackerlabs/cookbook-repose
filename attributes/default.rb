default['repose']['loglevel'] = 'DEBUG'

default['repose']['cluster_id'] = 'repose'
default['repose']['node_id'] = 'repose_node1'
default['repose']['port'] = 8080
default['repose']['ssl_port'] = 8443
default['repose']['connection_timeout'] = 30000
default['repose']['read_timeout'] = 30000
default['repose']['deploy_auto_clean'] = false
default['repose']['filter_check_interval'] = 60000

default['repose']['filters'] = []

default['repose']['peer_search_enabled'] = false
default['repose']['peer_search_role'] = 'repose'
default['repose']['peers'] = [
  { 'id' => 'repose_node1',
    'hostname' => 'localhost',
    'port' => 8080,
  }
]

default['repose']['endpoints'] = [
  { 'id' => 'open_repose',
    'protocol' => 'http',
    'hostname' => 'openrepose.org',
    'port' => 80,
    'root_path' => '/',
    'default' => true,
  }
]

default['repose']['dist_datastore']['allow_all'] = false
default['repose']['dist_datastore']['allowed_hosts'] = ['127.0.0.1']

default['repose']['http_logging']['id'] = 'http-log'
default['repose']['http_logging']['format'] = 'Remote IP=%a Local IP=%A Response Size(bytes)=%b Remote Host=%h Request Method=%m Server Port=%p Query String=%q Time Request Received=%t Status=%s Remote User=%u Rate Limit Group: %{X-PP-Groups}i URL Path Requested=%U X-Forwarded-For=%{X-Forwarded-For}i X-REAL-IP=%{X-Real-IP}i'
default['repose']['http_logging']['logfile'] = '/var/log/repose/http.log'

default['repose']['ip_identity']['quality'] = 0.2
default['repose']['ip_identity']['white_list_quality'] = 1.0
default['repose']['ip_identity']['white_list_ip_addresses'] = ['127.0.0.1']
