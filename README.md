# repose cookbook

[![Build Status](https://travis-ci.org/rackerlabs/cookbook-repose.svg?branch=master)](https://travis-ci.org/rackerlabs/cookbook-repose)

This cookbook installs, configures and manages Repose.

"REPOSE is an open-source RESTful HTTP proxy service that scales to the cloud. REPOSE provides the solution to common API processing tasks such as rate limiting, client authentication, versioning, and logging so that web service developers can focus on the unique features of their services." ~ http://openrepose.org/, 09/03/2013

# Requirements

Supports CentOS 6.5, Ubuntu 14.04, and Ubuntu 12.04.

Requires Repose v6.2.0 or greater due to package differences.

# Usage

Include `recipe[repose]` in your run_list and override attributes as required.

## Filters

There are 2 ways to setup filters:
  1. Include any of the `repose::filter-*` recipes *before* the `repose::default` recipe
  2. Add the filter names to the `node['repose']['filters']` array

Available filters are:
  * [add-header](https://repose.atlassian.net/wiki/display/REPOSE/Add+Header+Filter)
  * [api-validator](https://repose.atlassian.net/wiki/display/REPOSE/API+Validation+filter)
  * [client-auth](https://repose.atlassian.net/wiki/display/REPOSE/Client+Authentication+filter) (deprecated in Repose 8.0.0 - replace with Keystone v2 Filter)
  * [client-authorization](https://repose.atlassian.net/wiki/display/REPOSE/Client+Authorization+filter)
  * [content-type-stripper](https://repose.atlassian.net/wiki/display/REPOSE/Content+Type+Stripper+filter) (system-model only)
  * [CORS](https://repose.atlassian.net/wiki/display/REPOSE/CORS+filter)
  * [DeRP](https://repose.atlassian.net/wiki/display/REPOSE/Delegation+Response+Processor+%28DeRP%29+Filter)
  * [header-identity](https://repose.atlassian.net/wiki/display/REPOSE/Header+Identity+filter)
  * [header-normalization](https://repose.atlassian.net/wiki/display/REPOSE/Header+Normalization+filter)
  * [header-translation](https://repose.atlassian.net/wiki/display/REPOSE/Header+Translation+filter)
  * [ip-identity](https://repose.atlassian.net/wiki/display/REPOSE/IP+Identity+filter) (deprecated in Repose 8.0.0 - replace with IP User Filter)
  * [ip-user](https://repose.atlassian.net/wiki/display/REPOSE/IP+User+filter)
  * [keystone-v2](https://repose.atlassian.net/wiki/display/REPOSE/Keystone+v2+Filter)
  * [merge-header](https://repose.atlassian.net/wiki/display/REPOSE/Merge+Header+filter)
  * [rackspace-auth-user](https://repose.atlassian.net/wiki/display/REPOSE/Rackspace+Auth+User+filter)
  * [rate-limiting](https://repose.atlassian.net/wiki/display/REPOSE/Rate+Limiting+filter)
  * [slf4j-http-logging](https://repose.atlassian.net/wiki/display/REPOSE/SLF4J+HTTP+Logging+filter)
  * [translation](https://repose.atlassian.net/wiki/display/REPOSE/Translation+filter)
  * [uri-identity](https://repose.atlassian.net/wiki/display/REPOSE/URI+Identity+filter)
  * [uri-stripper](https://repose.atlassian.net/wiki/display/REPOSE/URI+Stripper+filter)
  * [url-extractor-to-header](https://repose.atlassian.net/wiki/display/REPOSE/URL+Extractor+to+Header)

Other filters are available in Repose and may be added to this cookbook in a later revision.

## Services

Services work the same way as filters. Just s/filter/service/g.

Available services are:
  * [dist-datastore] (https://repose.atlassian.net/wiki/display/REPOSE/Datastores#Datastores-distributedDistributedDatastore)
  * [http-connection-pool] (https://repose.atlassian.net/wiki/display/REPOSE/HTTP+Connection+Pool+service) (configuration only)
  * [response-messaging] (https://repose.atlassian.net/wiki/display/REPOSE/Response+Messaging+service)
  * [open-tracing] (http://www.openrepose.org/versions/latest/services/open-tracing.html)

## Nodes

There are also 2 ways to setup nodes in `system-model.cfg.xml`:
  1. Override the `node['repose']['peers']` array as shown below. Note that peers without a `cluster_id` are assumed to belong to all clusters. This is almost certainly not correct if more than 1 cluster is being configured but is implemented to maintain functionality with earlier versions of the cookbook.
  2. Set `node['repose']['peer_search_enabled']` to `true`. For each Chef node found this way peers will be loaded according to the `node['repose']['cluster_ids']`, `node['repose']['node_id']`, `node['fqdn']`, `node['repose']['port']`, and `node['repose']['ssl_port']` attributes. `node_id` and `fqdn` will be consistant for each `cluster_id` in `cluster_ids`. `port` and `ssl_port` will be incremented by 1 for each `cluster_id` in `cluster_ids`.

## Endpoints

Setup endpoint in `system-model.cfg.xml` by overriding the `node['repose']['endpoints']` array as shown below. Note that endpoints without a `cluster_id` are assumed to belong to all clusters. This is almost certainly not correct if more than 1 cluster is being configured but is implemented to maintain functionality with earlier versions of the cookbook.

# Attributes

## General attributes

* `node['repose']['owner']` - The Repose user. `root` on Ubuntu and `repose` on CentOS.
* `node['repose']['group']` - The Repose primary group. `root` on Ubuntu and `repose` on CentOS.
* `node['repose']['install_opts']` - Command line options used for installing pacakges.
* `node['repose']['loglevel']` - The log level for the main Repose log file.
* `node['repose']['cluster_ids']` - An array of cluster IDs.
* `node['repose']['node_id']` - The node ID.
* `node['repose']['port']` - The port to bind to.
* `node['repose']['ssl_port']` - The SSL port to bind to.
* `node['repose']['config_directory']` - Configuration directory location.
* `node['repose']['log_path']` - Log directory location.
* `node['repose']['pid_file']` - PID file location.
* `node['repose']['java_opts']` - Java options specific to Repose. This is distinct from the system environmment variable `JAVA_OPTS`.
* `node['repose']['shutdown_port']` - The shutdown port to bind to.
* `node['repose']['connection_timeout']` - The connection timeout in ms.
* `node['repose']['read_timeout']` The read timeout in ms.
* `node['repose']['deploy_auto_clean']` - Auto-clean the deploy directory if `true`.
* `node['repose']['filter_check_interval']` - The filter check interval in ms.
* `node['repose']['filters']` - An array of filters to load. Loading the `repose::filter-*` recipes will update this if required.
* `node['repose']['services']` - An array of services to load. Loading the `repose::service-*` recipes will update this if required.

## Repository attributes

* `node['repose']['repo']['managed']` - Whether or not to manage the Repose repository. If `false` the recipes will assume the Repose repository is already configured.
* `node['repose']['repo']['baseurl']` - The base URL of the Repose repository.
* `node['repose']['repo']['gpgkey']` - The GPG key used to sign Repose packages.
* `node['repose']['repo']['gpgcheck']` - Whether or not to check package signatures. `rhel` only.
* `node['repose']['repo']['enabled']` - Whether or not the repository is enabled by default. `rhel` only.

These attributes should have reasonable, platform_family specific defaults.

## Peer attributes

* `node['repose']['peer_search_enabled']` - The `repose::default` recipe loads the `repose::load_peers` recipe if `true`.
* `node['repose']['peer_search_query']` - The query to use to search for Repose peers.
* `node['repose']['peers']` - An array of Repose peers.

The Repose peers array defaults to:
```
[
  { 'cluster_id' => 'repose',
    'id' => 'repose_node1',
    'hostname' => 'localhost',
    'port' => 8080,
  }
]
```

## Endpoint attributes

* `node['repose']['endpoints']` - An array of Repose endponts.

The Repose endpoints array defaults to:
```
[
  { 'cluster_id' => 'repose',
    'id' => 'open_repose',
    'protocol' => 'http',
    'hostname' => 'openrepose.org',
    'port' => 80,
    'root_path' => '/',
    'default' => true,
  }
]
```

## dist-datastore attributes

* `node['repose']['dist_datastore']['cluster_id']` - An array of cluster IDs that use this service or `['all']` for all cluster IDs.
* `node['repose']['dist_datastore']['allow_all']` - Allow all hosts to use the dist-datastore if `true`. Be aware that this basically turns off security around the dist-datastore. Use with care.
* `node['repose']['dist_datastore']['allowed_hosts']` - An array of hosts to whitelist for the dist-datastore.
* `node['repose']['dist_datastore']['port']` - The port to use for dist-datastore. Set to `nil` to leave out the `<port-config>` block. Will be incremented by 1 for each `cluster_id` in `node['repose']['cluster_ids']`.

## slf4j-http-logging attributes

* `node['repose']['slf4j_http_logging']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['slf4j_http_logging']['id']` - The log ID.
* `node['repose']['slf4j_http_logging']['format']` - The log format.

## ip-identity attributes

* `node['repose']['ip_identity']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['ip_identity']['quality']` - The default quality.
* `node['repose']['ip_identity']['white_list_quality']` - The whitelist quality.
* `node['repose']['ip_identity']['white_list_ip_addresses']` - An array of whitelisted IP addresses.

## keystone-v2 attributes

* `node['repose']['keystone_v2']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['keystone_v2']['username_admin']` - Administrator username making auth-n requests for clients.
* `node['repose']['keystone_v2']['password_admin']` - Administrator password making auth-n requests for clients.
* `node['repose']['keystone_v2']['uri']` - target URI (i.e., the URI of your Identity Service endpoint) for authentication requests.
* `node['repose']['keystone_v2']['pool']` - Tells the connection pool service to map to the pool with specified id. If default is chosen, the default connection pool configurations in connection pool service is used.
* `node['repose']['keystone_v2']['groups_in_header']` - Set the user's groups in the x-pp-groups header. If the user has no groups, the header will not be set.
* `node['repose']['keystone_v2']['roles_in_header']` - Set the user's roles in the x-roles header.
* `node['repose']['keystone_v2']['catalog_in_header']` - Set the user's service catalog in the x-catalog header.
* `node['repose']['keystone_v2']['delegating_quality']` - If present, the filter will not send a failing response when an invalid state is reached. Instead, it will add the data relating to the failure to a header and forward the request to be handled by a different filter or service.  If not present, the filter will send a failing response when an invalid state is reached.  The quality, a double between 0 and 1, assigned to the delegation header on delegation. This value will be used to order delegation based on priority when multiple delegations are present.
* `node['repose']['keystone_v2']['white_list']` - A list of URI patterns all users can access.
```
white_list = ['$/v1','$/v1/application.wadl$']
```
* `node['repose']['keystone_v2']['cache']` - A container element for all configuration associated with caching.	Can provide timeouts for token, endpoints, and groups and a list of atom feeds
```
cache = {
  'timeout_variability' => 10,
  'token_timeout' => 10,
  'group_timeout' => 10,
  'endpoints_timeout' => 10,
  'atom_feeds' => [
    'feedOne',
    'feedTwo'
  ]
}
```
* `node['repose']['keystone_v2']['tenant_handling']` - A container element for all configuration associated with tenants.
```
tenant_handling = {
  'send_all_tenant_ids' => false,
  'validate_tenant' => {
     'strip_token_tenant_prefixes' => '/test/',
     'url_extraction_regex' => '/v1/servers/.*'
  },
  'send_tenant_id_quality' = {
     'default' => '1.0',
     'roles' => '0.5',
     'uri' => '0.3'
  }
}
```
* `node['repose']['keystone_v2']['require_service_endpoint']` - If this element is included, authorization will be enforced. The use associated with the provided x-auth-token must have an endpoint meeting the criteria defined by the attributes in this element.
```
require_service_endpoint = {
  'public_url' => 'https://somethingorother',
  'region' => 'DFW',
  'name' => 'myservice',
  'type' => 'myservicecatalogentry'
}
```
* `node['repose']['keystone_v2']['pre_authorized_roles']` - If tenant ID validation is enabled, the Keystone v2 filter can be configured to bypass the check for certain requests. To do so, add the <pre-authorized-roles> element to your configuration file as a child of the root element. This element will have <role> children elements which define the roles for which the tenant ID check does not occur. These roles will be compared to the roles returned in a token from the Keystone v2 service, and if there is a match, the project ID check will be skipped.
```
pre_authorized_roles = ['observer','admin']
```

## client-auth attributes

* `node['repose']['client_auth']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['client_auth']['auth_provider']` - The authentication provider to use, either 'RACKSPACE' for Rackspace cloud, or else 'OPENSTACK' for Keystone
* `node['repose']['client_auth']['username_admin']` - Administrator username making auth-n requests for clients.
* `node['repose']['client_auth']['password_admin']` - Administrator password making auth-n requests for clients.
* `node['repose']['client_auth']['auth_uri']` - URI for the authentication service.
* `node['repose']['client_auth']['tenanted']` - Whether the tenant_id will be parsed from the request uri.  If this is set to true then mapping_regex must be provided.
* `node['repose']['client_auth']['mapping_regex']` - Optional regex to extract the user/tenant/account information from URI.
    * For example this regex `.*/v1/([-|\w]+)/?.*` will provide this action: '/v1/853473/action => x-pp-user=853473'. Used with the 'CLOUD' Rackspace mapping_type below.
    * For example this regex `.*.com/service/([-|\w]+)/?.*` will provide this action: '/service/853473/action => x-pp-user=853473'. Used with the 'MOSSO' Rackspace mapping_type below.
* `node['repose']['client_auth']['mapping_type']` - (Rackspace only, required if 'mapping_regex' is provided) One of 'CLOUD' or 'MOSSO'.
* `node['repose']['client_auth']['tenant_id']` - (Keystone only, optional) Tenant-ID with admin role for the admin user above.
* `node['repose']['client_auth']['delegable']` - Whether auth is delegable.

* `node['repose']['client_auth']['request_groups']` - Whether repose requests the user's list of groups from the identity service.
* `node['repose']['client_auth']['token_cache_timeout']` - Timeout for token cache.
* `node['repose']['client_auth']['group_cache_timeout']` - Timeout for group cache.
* `node['repose']['client_auth']['endpoints_in_header']` - Enable or disable the listing of service endpoints in the header.

* `node['repose']['client_auth']['white_list']` - You can configure Repose authentication to allow the processing of requests that do not require authentication. Default to `false`.
* `node['repose']['client_auth']['uri_regex']` - The whitelist contains a list of regular expressions Repose will attempt to match against the full request URI. If the URI matches a regular expression on the white list, the request is passed to the origin service. Otherwise, authentication is performed against the request.

## rate-limit attributes

* `node['repose']['rate_limiting']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['rate_limiting']['uri_regex']` - A regular expression (regex) for the URI at which the user can query their limits.
* `node['repose']['rate_limiting']['include_absolute_limits']` - Enables or disables integration with absolute limits.
* `node['repose']['rate_limiting']['global_limits']` - An array of global limits.  Defaults to empty thus disabled.
* `node['repose']['rate_limiting']['limit_groups']` - An array of limit groups.

The limit groups array defaults to:
```
[
  { 'id' => 'limited',
    'groups' => 'limited',
    'default' => true,
    'limits' => [
      { 'id' => 'all',
        'uri' => '*',
        'uri_regex' => '/.*',
        'http_methods' => 'POST PUT GET DELETE',
        'unit' => 'MINUTE',
        'value' => 10
      }
    ]
  },
  { 'id' => 'unlimited',
    'groups' => 'unlimited',
    'default' => false,
    'limits' => []
  }
]
```

Global limit groups are similarly organized:
```
[
  { 'id' => 'create-server',
    'uri' => '/server/create',
    'uri-regex' => '/server/create/?',
    'method' => 'POST',
    'value' => 10,
    'unit' => 'SECOND'
  }
]
```

## header-translation attributes

* `node['repose']['header_translation']['headers']` - header list of original headers (the ones passed in the request) and the new headers (the ones that will have duplicate values of original headers).  new_name can be a list of headers white-space separated. You can also set an optional remove_attribute key if you'd like the original header to be removed.  to set the array.

The default headers are:
```
[
  { 'original_name' => 'Content-Type',
    'new_name' => 'rax-content-type'
  },
  { 'original_name' => 'Content-Length',
    'new_name' => 'rax-content-length not-rax-content-length something-else',
    'remove_original' => true
  }
]
```

## header-identity attributes

* `node['repose']['header_identity']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['header_identity']['headers']` - Lists the headers to identify the incoming user.

The default headers are:
```
[
  { 'id' => 'X-Auth-Token',
    'quality' => 0.95
  },
  { 'id' => 'X-Forwarded-For',
    'quality' => 0.5
  }
]
```

## header-normalization attributes

* `node['repose']['header_normalization']['whitelist']` - a hash of whitelist blocks, each encapsulating an array of headers to be whitelisted by Repose for delivery to the origin service or next filter in the chain. A unique 'id' key identifies each whitelist entry, with optional 'uri_regex' and 'http_methods' keys to induce further constraints.
* `node['repose']['header_normalization']['blacklist']` - a hash of blacklist blocks, each encapsulating an array of headers to be blacklisted by Repose for non-delivery to the origin service or next filter in the chain. A unique 'id' key identifies each blacklist entry, with optional 'uri_regex' and 'http_methods' keys to induce further constraints.

The default whitelist is:
```
[
  { 'id' => 'credentials',
    'uri_regex' => '/servers/(.*)',
    'headers'   => ['X-Auth-Key','X-Auth-User']
  },
  { 'id' => 'modification',
    'uri_regex' => '/resource/(.*)',
    'http_methods' => 'PUT POST',
    'headers'   => ['X-Modify']
  }
]
```

The default blacklist is:
```
[
  { 'id' => 'rate-limit-headers',
    'headers'   => ['X-PP-User','X-PP-Groups']
  }
]
```

## merge-header attributes

* `node['repose']['merge_header']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['merge_header']['response_headers']` - An array of response headers to merge into one
* `node['repose']['merge_header']['request_headers']` - An array of response headers to merge into one

The default response_headers and request_headers are:
```
[]
```
which means no headers to merge and this filter becomes a no-op. An example to override it:
```
node['repose']['merge_header']['response_headers'] = [
    'HEADER1', 'HEADER2'
]
node['repose']['merge_header']['request_headers'] = [
    'HEADER1', 'HEADER2'
]
```

## content-type-stripper attributes

* `node['repose']['content_type_stripper']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.

## CORS attributes

* `node['repose']['cors']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['cors']['allowed_origins']` - An array of origin objects
* `node['repose']['cors']['allowed_methods']` - An array of methods that are allowed to access origin service
* `node['repose']['cors']['resources']` - An array of resource specific CORS that are allowed to be accessed. Each resource consists of path and an array of allowed_methods 

The default allowed_origins is:
```
[
  { 'is_regex' => true,
    'value'    => '.*'
  }
]
```
which means all origins are allowed

The default allowed_methods is:
```
[]
```
which means all methods are allowed

The default resources is:
```
[]
```
which means all resources are allowed to be accessed. An example configuration that overrides the default resources:
```
node['repose']['cors']['resources'] = [
  { 'path'            => '/resource1/.*',
    'allowed_methods' => [
      'GET'
     ]
  }
]
```
which means only GET methods are allowed for CORS requests to "/resource1/.*"


## http-connection-pool attributes

* `node['repose']['http_connection_pool']['chunked_encoding']` - Use the default unless your programming language does not support chunked encoding. Some Repose filters modify request bodies. Due to this possibility Repose will, by default, send requests with entities as chunked. Setting chunked-encoding to false will cause Repose to attempt to evaluate the actual content length of the request by reading the ServletInputStream. Default is true.
* `node['repose']['http_connection_pool']['max_total']` - Maximum number of connections that Repose opens across all endpoints. (If set too high, you might run out of memory.) Default is 400.
* `node['repose']['http_connection_pool']['max_per_route']` - Maximum number of connections that Repose opens per endpoint. Default is 200.
* `node['repose']['http_connection_pool']['socket_timeout']` - Number of milliseconds a request is in flight before it times out. Default is 30000.
* `node['repose']['http_connection_pool']['connection_timeout']` - Number of milliseconds a connection waits to send a request. Default is 30000.
* `node['repose']['http_connection_pool']['socket_buffer_size']` - Default is 8192.
* `node['repose']['http_connection_pool']['connection_max_line_length']` - Default is 8192.
* `node['repose']['http_connection_pool']['connection_max_header_count']` - Maximum number of headers that can be sent in the request. Default is 100.
* `node['repose']['http_connection_pool']['connection_max_status_line_garbage']` - Maximum number of lines allotted for garbage. Default is 100.
* `node['repose']['http_connection_pool']['tcp_nodelay']` - Default is true.
* `node['repose']['http_connection_pool']['keepalive_timeout']` - If a Keep-Alive header is not present in the response, the value of keepalive.timeout is evaluated. If this value is 0, the connection will be kept alive indefinitely. If the value is greater than 0, the connection will be kept alive for the number of milliseconds specified. Set to 1 to connect:close. Default is 0.

## translation attributes

* `node['repose']['translation']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['translation']['allow_doctype_decl']` - If false, then any request/response body that contains an DOCTYPE section will be rejected.  If true, then DOCTYPE sections will be allowed.
* `node['repose']['translation']['request_translations']` - Enumerated translations that specify a chain of stylesheets to be applied to a request request body and the criteria for when the chain should be applied.
* `node['repose']['translation']['response_translations']` - Enumerated translations that specify a chain of stylesheets to be applied to a request response body and the criteria for when the chain should be applied.

The default values for request\_translations and response\_translations are `[]` because no sensable examples exist for a generic origin service. See the online documentation for configuration examples.

## rackspace-auth-user attributes

* `node['repose']['rackspace_auth_user']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['rackspace_auth_user']['v1_1']['enabled']` - Specifies whether version 1.1 of the Rackspace identity contract should be parsed.
* `node['repose']['rackspace_auth_user']['v1_1']['read_limit']` - Specifies the size of the content.
* `node['repose']['rackspace_auth_user']['v1_1']['group']` - Defines the X-PP Groups header for this filter.
* `node['repose']['rackspace_auth_user']['v1_1']['quality']` - Defines the quality assigned to the header.
* `node['repose']['rackspace_auth_user']['v2_0']['enabled']` - Specifies whether version 2.0 of the Rackspace identity contract should be parsed.
* `node['repose']['rackspace_auth_user']['v2_0']['read_limit']` - Specifies the size of the content.
* `node['repose']['rackspace_auth_user']['v2_0']['group']` - Defines the X-PP Groups header for this filter.
* `node['repose']['rackspace_auth_user']['v2_0']['quality']` - Defines the quality assigned to the header.

## uri-identity attributes

* `node['repose']['uri_identity']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['uri_identity']['mappings']` - An array of regular expressions used to extract the identification information from the request URI.
* `node['repose']['uri_identity']['group']` - Names the rate limiting group associated with the extracted identification data.
* `node['repose']['uri_identity']['quality']` - Defines the quality assigned to user by the incoming identification data.

The default mappings are:
```
[
  '.*/servers/(\w*)/.*',
  '.*/servers/(\w*)/.*'
]
```

## api-validator attributes

* `node['repose']['api_validator']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['api_validator']['enable_rax_roles']` - Enables the use of rax:roles in WADL files to determine resource access. If set to true, rax:roles defined in the supplied WADL files will be used to determine resource access and check-headers will also be enabled regardless of your setting. If set to false, rax:roles defined in WADL files are not used to determine resource access. Default is false.
* `node['repose']['api_validator']['wadl']` - The WADL/Checker Document location can be specified as an absolute path or as a relative path to Repose's configuration root directory. The path is not a URL; it is a path on the filesystem.
* `node['repose']['api_validator']['dot_output']` - Dot output file for this validator.

The files pointed to by `node['repose']['api_validator']['wadl']` and `node['repose']['api_validator']['dot_output']` should be created either in a wrapper or in the application cookbook.

## client-authorization attributes

* `node['repose']['client_authorization']['username_admin']` - Adminstrator username making auth-n requests for clients.
* `node['repose']['client_authorization']['password_admin']` - Adminstrator password making auth-n requests for clients.
* `node['repose']['client_authorization']['auth_uri']` - URI for the authentication service.
* `node['repose']['client_authorization']['tenant_id_admin']` - Optional. Tenant ID for the auth user.
* `node['repose']['client_authorization']['endpoint_list_ttl']` - Optional. Time to live in seconds for cached endpoint listings.
* `node['repose']['client_authorization']['connection_pool_id']` - Optional. ID of connection to service pool.
* `node['repose']['client_authorization']['service_endpoint']` - The URI to expect in the client's catalog.
* `node['repose']['client_authorization']['service_region']` - Optional. The service region to expect in the client's catalog.
* `node['repose']['client_authorization']['service_name']` - Optional. The service name to expect in the client's catalog.
* `node['repose']['client_authorization']['service_type']` - Optional. The service type to expect in the client's catalog.
* `node['repose']['client_authorization']['ignore_tenant_roles']` - Optional. List of roles that bypass the tenant requirement check.
* `node['repose']['client_authorization']['roles']` - Optional. List of roles that bypass the tenant requirement check.
* `node['repose']['client_authorization']['delegating_quality']` - Optional. A double in the range [0..1] assigned to the delegation header. Used to organize delegation order by priority.

## uri-stripper attributes

* `node['repose']['uri_stripper']['rewrite_location']` - The rewrite location for the Location header.
* `node['repose']['uri_stripper']['token_index']` - The token index to be removed from the request path.

## uri-extractor-to-header attributes

* `node['repose']['uri_extractor_to_header']['extractor_headers']` - Hash of headers to insert into requests (client -> origin).
Example hash of inserting headers into requests:

```
{ 'name' => 'X-Inbound-Header',
  'url_regex' => '\some\random\.*\url',
  'default' => ""
}
```

## add-header attributes

* `node['repose']['add_header']['requests']` - Optional.  Hash of headers to insert into requests (client -> origin)

Example hash of inserting headers into requests:

```
{ 'name' => 'X-Inbound-Header',
  'quality' => 0.5,
  'overwrite' => false,
  'value' => 'Salud Origin'
}
```
* `node['repose']['add_header']['responses']` - Optional. Hash of headers to insert into responses (origin -> client)

Example hash of inserting headers into responses:

```
{ 'name' => 'X-Outbound-Header',
  'quality' => 0.5,
  'overwrite' => false,
  'value' => 'Bonjour Client'
}
```

## response-messaging attributes

* `node['repose']['response_messaging']['status_codes'] - Array of status codes to activate on and generate responses.
Example of configuration:
```
[{ 'id'         => 'test_bad_input',
   'code_regex' => '4..',
   'overwrite'  => 'ALWAYS',
   'messages'   => [
       { 'media_type'   => 'application/xml',
         'content_type' => 'text/plain',
         'content'      => '<![CDATA[<test/>]]>'},
       { 'media_type'   => '*/*',
         'content_type' => 'application/json',
         'content'      => '{"test":"bad"}'}]},
       { 'id'         => 'test_error',
         'code_regex' => '5..',
         'overwrite'  => 'ALWAYS',
         'messages'   => [
             { 'media_type'   => 'application/xml',
               'content_type' => 'text/plain',
               'content'      => '<![CDATA[<error/>]]>'},
             { 'media_type'   => '*/*',
               'content_type' => 'application/json',
               'content'      => '{"test":"error"}'}]}]
```

## open-tracing attributes

* `node['repose']['open_tracing']['connection_type']` - String that is set to either `udp` or `http`.  Sets the type of connection to tracer endpoint.  Default is `http`.
* `node['repose']['open_tracing']['http']['endpoint']` - URL address to the tracing collector.  Default is `http://localhost:12682/api/traces`
* `node['repose']['open_tracing']['http']['username']` - Optional user name for authentication to collector. Must be used in tandem with `password`.
* `node['repose']['open_tracing']['http']['password']` - Optional password for authentication to collector. Must be used in tandem with `username`.
* `node['repose']['open_tracing']['http']['token']` - Optional BEARER token for authentication to collector.
* `node['repose']['open_tracing']['udp']['host']` - Hostname or IP address of the tracer agent.  Default is `localhost`.
* `node['repose']['open_tracing']['udp']['port']` - Port of the tracer agent.  Default is `5775`.
* `node['repose']['open_tracing']['sampling_type']` - String that is set to either `constant`, `probabilistic`, or `rate-limiting`.  Sets the sampling algorithm.  Default is `constant`.
* `node['repose']['open_tracing']['constant']['toggle']` - Setting on whether or not to collect data. Either `on` or `off`.  Default is `off`.
* `node['repose']['open_tracing']['probabilistic']['probability']` - Optional double on how many requests to sample (e.g. `0.001` means 1 out of every 1000 requests gets sampled).
* `node['repose']['open_tracing']['rate_limiting']['max_traces_per_second']` - Optional double on how many traces per second to sample.

# Recipes

## default

Installs and configures Repose. May include all other recipes.

## install

Install Repose only. Loads the appropriate install recipe based on platform family. This recipe is not meant to be used directly.

## install_debian

Install Repose on the Debian family of systems. This recipe is not meant to be used directly.

## install_rhel

Install Repose on the RHEL family of systems. This recipe is not meant to be used directly.

## load_peers

Uses chef-search to find nodes with a matching Chef environment, search role, and cluster ID, maps them to hashes representing Repose peers, and loads them into the `node['repose']['peers']` array. Not meant to be called directly unless a different cookbook wants to find Repose nodes. E.g. maybe Nginx uses Repose nodes as a backend and wants to consume `node['repose']['peers']`.

## filter-* or service-*

Setup a paticular filter or service. *Must* be called before `repose::default`.

# Vagrant

This cookbook includes support for Vagrant. Start the VM by following these steps

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](http://downloads.vagrantup.com/)
3. Run `bundle install`
4. Run `vagrant plugin install vagrant-berkshelf`
5. Run `vagrant plugin install vagrant-omnibus`
6. Run `vagrant up`

# Tests

This cookbook includes support for test-kitchen and chefspec unit tests. Run the test suite with

```
kitchen test
```

# Author(s)

* Author: Brendan ODonnell (<brendan.odonnell@rackspace.com>)
* Author: Nick Silkey (<nick.silkey@rackspace.com>)
* Author: Dimitry Ushakov  (<dimitry.ushakov@rackspace.com>)
