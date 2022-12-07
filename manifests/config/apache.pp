# @summary Configure the foreman service using Apache
#
# @param app_root
#   Root of the application.
#
# @param priority
#   Apache vhost priority
#
# @param servername
#   Servername for the vhost.
#
# @param serveraliases
#   Serveraliases for the vhost.
#
# @param server_port
#   Port for Apache to listen on HTTP requests
#
# @param server_ssl_port
#   Port for Apache to listen on HTTPS requests
#
# @param ssl
#   Whether to enable SSL.
#
# @param ssl_cert
#   Location of the SSL certificate file.
#
# @param ssl_key
#   Location of the SSL key file.
#
# @param ssl_ca
#   Location of the SSL CA file
#
# @param ssl_chain
#   Location of the SSL chain file
#
# @param ssl_crl
#   Location of the SSL certificate revocation list file
#
# @param ssl_protocol
#   SSLProtocol configuration to use
#
# @param ssl_verify_client
#   The level of SSL client verification to apply
#
# @param user
#   The user under which the application runs.
#
# @param proxy_add_headers
#   Do not set X-Forwarded-* headers. Useful when having another
#   balancing layer in front of this Apache instance.
#
# @param proxy_backend
#   The backend service to proxy to
#
# @param proxy_params
#   The proxy parameters to use when proxying
#
# @param proxy_no_proxy_uris
#   URIs not to proxy
#
# @param proxy_assets
#   Whether assets paths (/assets, /webpack) should be proxied or not.
#
# @param foreman_url
#   The URL Foreman should be reachable under. Used for loading the application
#   on startup rather than on demand.
#
# @param access_log_format
#   Apache log format to use
#
# @param ipa_authentication
#   Whether to install support for IPA authentication
#
# @param http_vhost_options
#   Direct options to apache::vhost for the http vhost
#
# @param https_vhost_options
#   Direct options to apache::vhost for the https vhost
#
# @param keycloak
#   Whether to enable keycloak support
#
# @param keycloak_app_name
#   The app name as passed to keycloak-httpd-client-install
#
# @param keycloak_realm
#   The realm as passed to keycloak-httpd-client-install
#
# @param request_headers_to_unset A list of HTTP headers coming from
#   the client that will be unset and hence not passed to the
#   application.
class foreman::config::apache (
  Stdlib::Absolutepath $app_root = '/usr/share/foreman',
  String $priority = '05',
  Stdlib::Fqdn $servername = $facts['networking']['fqdn'],
  Array[Stdlib::Fqdn] $serveraliases = [],
  Stdlib::Port $server_port = 80,
  Stdlib::Port $server_ssl_port = 443,
  Pattern['^(https?|unix)://'] $proxy_backend = 'unix:///run/foreman.sock',
  Boolean $proxy_add_headers = true,
  Hash $proxy_params = { 'retry' => '0' },
  Array[String] $proxy_no_proxy_uris = ['/pulp', '/pub', '/icons', '/server-status'],
  Boolean $proxy_assets = false,
  Boolean $ssl = false,
  Optional[Stdlib::Absolutepath] $ssl_ca = undef,
  Optional[Stdlib::Absolutepath] $ssl_chain = undef,
  Optional[Stdlib::Absolutepath] $ssl_cert = undef,
  Optional[Stdlib::Absolutepath] $ssl_key = undef,
  Variant[Undef, Enum[''], Stdlib::Absolutepath] $ssl_crl = undef,
  Optional[String] $ssl_protocol = undef,
  Enum['none','optional','require','optional_no_ca'] $ssl_verify_client = 'optional',
  Optional[String] $user = undef,
  Optional[Stdlib::HTTPUrl] $foreman_url = undef,
  Optional[String] $access_log_format = undef,
  Boolean $ipa_authentication = false,
  Hash[String, Any] $http_vhost_options = {},
  Hash[String, Any] $https_vhost_options = {},
  Boolean $keycloak = false,
  String[1] $keycloak_app_name = 'foreman-openidc',
  String[1] $keycloak_realm = 'ssl-realm',
  Array[String[1]] $request_headers_to_unset = [
    'REMOTE_USER',
    'REMOTE_USER_EMAIL',
    'REMOTE_USER_FIRSTNAME',
    'REMOTE_USER_LASTNAME',
    'REMOTE_USER_GROUPS',
  ],
) {
  $docroot = "${app_root}/public"

  if $proxy_backend =~ 'unix://' {
    $_proxy_backend = "${proxy_backend}|http://foreman/"
  } else {
    $_proxy_backend = regsubst($proxy_backend, 'tcp://', 'http://')
  }

  if $foreman_url {
    $suburi_parts = split($foreman_url, '/')
    $suburi_parts_count = size($suburi_parts) - 1
    if $suburi_parts_count >= 3 {
      $suburi_without_slash = join(values_at($suburi_parts, ["3-${suburi_parts_count}"]), '/')
      if $suburi_without_slash {
        $suburi = "/${suburi_without_slash}"
      } else {
        $suburi = undef
      }
    } else {
      $suburi = undef
    }
  } else {
    $suburi = undef
  }

  if $suburi {
    $custom_fragment = undef
  } else {
    # mod_env and mod_expires are required by configuration in _assets.conf.erb
    include apache::mod::env
    # apache::mod::expires pulls in a config file we don't want, like apache::default_mods
    # It uses ensure_resource to be compatible with both $apache::default_mods set to true and false
    include apache
    ensure_resource('apache::mod', 'expires')
    $custom_fragment = file('foreman/_assets.conf.erb')
  }

  # This sets the headers matching what $vhost_https_internal_options sets
  foreman::settings_fragment { 'reverse-proxy-headers.yaml':
    content => file('foreman/settings-reverse-proxy-headers.yaml'),
    order   => '03',
  }

  include apache::mod::proxy_wstunnel
  $websockets_backend = regsubst($_proxy_backend, 'http://', 'ws://')

  $vhost_http_request_headers = [
    'set X_FORWARDED_PROTO "http"',
    'set SSL_CLIENT_S_DN ""',
    'set SSL_CLIENT_CERT ""',
    'set SSL_CLIENT_VERIFY ""',
  ] +
  $request_headers_to_unset.map |$header| {
    "unset ${header}"
  }

  if $proxy_assets {
    $_proxy_no_proxy_uris = $proxy_no_proxy_uris
  } else {
    $_proxy_no_proxy_uris = $proxy_no_proxy_uris + ['/webpack', '/assets']
  }

  $vhost_http_internal_options = {
    'proxy_preserve_host' => true,
    'proxy_add_headers'   => $proxy_add_headers,
    'request_headers'     => $vhost_http_request_headers,
    'proxy_pass'          => {
      'no_proxy_uris' => $_proxy_no_proxy_uris,
      'path'          => pick($suburi, '/'),
      'url'           => $_proxy_backend,
      'params'        => $proxy_params,
    },
    'rewrites'            => [
      {
        'comment'      => 'Upgrade Websocket connections',
        'rewrite_cond' => '%{HTTP:Upgrade} =websocket [NC]',
        'rewrite_rule' => "/(.*) ${websockets_backend}\$1 [P,L]",
      },
    ],
  }

  $vhost_https_request_headers = [
    'set X_FORWARDED_PROTO "https"',
    'set SSL_CLIENT_S_DN "%{SSL_CLIENT_S_DN}s"',
    'set SSL_CLIENT_CERT "%{SSL_CLIENT_CERT}s"',
    'set SSL_CLIENT_VERIFY "%{SSL_CLIENT_VERIFY}s"',
  ] +
  $request_headers_to_unset.map |$header| {
    "unset ${header}"
  }

  $vhost_https_internal_options = $vhost_http_internal_options + {
    'ssl_proxyengine' => true,
    'request_headers' => $vhost_https_request_headers,
  }

  if $facts['os']['selinux']['enabled'] {
    selboolean { 'httpd_can_network_connect':
      persistent => true,
      value      => 'on',
    }
  }

  include apache
  include apache::mod::headers

  if $ipa_authentication {
    include apache::mod::authnz_pam
    include apache::mod::intercept_form_submit
    include apache::mod::lookup_identity
    include apache::mod::auth_gssapi
  } elsif $keycloak {
    include apache::mod::auth_openidc

    # This file is generated by keycloak-httpd-client-install and that manages
    # the content. The command would be:
    #
    # keycloak-httpd-client-install --app-name ${keycloak_app_name} --keycloak-server-url $KEYCLOAK_URL --keycloak-admin-username $KEYCLOAK_USER --keycloak-realm ${keycloak_realm} --keycloak-admin-realm master --keycloak-auth-role root-admin --client-type openidc --client-hostname ${servername} --protected-locations /users/extlogin
    #
    # If $suburi is used, --location-root should also be passed in
    #
    # By defining it here we avoid purging it and also tighten the
    # permissions so the world can't read its secrets.
    # This is functionally equivalent to apache::custom_config without content/source
    file { "${apache::confd_dir}/${keycloak_app_name}_oidc_keycloak_${keycloak_realm}.conf":
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0640',
    }
  }

  file { "${apache::confd_dir}/${priority}-foreman.d":
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    purge   => true,
    recurse => true,
  }

  apache::vhost { 'foreman':
    add_default_charset   => 'UTF-8',
    docroot               => $docroot,
    manage_docroot        => false,
    options               => ['SymLinksIfOwnerMatch'],
    port                  => $server_port,
    priority              => $priority,
    servername            => $servername,
    serveraliases         => $serveraliases,
    access_log_format     => $access_log_format,
    additional_includes   => ["${apache::confd_dir}/${priority}-foreman.d/*.conf"],
    use_optional_includes => true,
    custom_fragment       => $custom_fragment,
    *                     => $vhost_http_internal_options + $http_vhost_options,
  }

  if $ssl {
    if $ssl_crl and $ssl_crl != '' {
      $ssl_crl_real = $ssl_crl
      $ssl_crl_check = 'chain'
    } else {
      $ssl_crl_real = undef
      $ssl_crl_check = undef
    }

    file { "${apache::confd_dir}/${priority}-foreman-ssl.d":
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      purge   => true,
      recurse => true,
    }

    apache::vhost { 'foreman-ssl':
      add_default_charset   => 'UTF-8',
      docroot               => $docroot,
      manage_docroot        => false,
      options               => ['SymLinksIfOwnerMatch'],
      port                  => $server_ssl_port,
      priority              => $priority,
      servername            => $servername,
      serveraliases         => $serveraliases,
      ssl                   => true,
      ssl_cert              => $ssl_cert,
      ssl_key               => $ssl_key,
      ssl_chain             => $ssl_chain,
      ssl_ca                => $ssl_ca,
      ssl_crl               => $ssl_crl_real,
      ssl_crl_check         => $ssl_crl_check,
      ssl_protocol          => $ssl_protocol,
      ssl_verify_client     => $ssl_verify_client,
      ssl_options           => '+StdEnvVars +ExportCertData',
      ssl_verify_depth      => 3,
      access_log_format     => $access_log_format,
      additional_includes   => ["${apache::confd_dir}/${priority}-foreman-ssl.d/*.conf"],
      use_optional_includes => true,
      custom_fragment       => $custom_fragment,
      *                     => $vhost_https_internal_options + $https_vhost_options,
    }
  }
}
