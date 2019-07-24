# Configure the foreman service using Apache
#
# === Parameters:
#
# $app_root::                 Root of the application.
#
# $passenger_ruby::           Path to Ruby interpreter
#
# $priority::                 Apache vhost priority
#
# $servername::               Servername for the vhost.
#
# $serveraliases::            Serveraliases for the vhost.
#
# $server_port::              Port for Apache to listen on HTTP requests
#
# $server_ssl_port::          Port for Apache to listen on HTTPS requests
#
# $ssl::                      Whether to enable SSL.
#
# $ssl_cert::                 Location of the SSL certificate file.
#
# $ssl_certs_dir::            Location of additional certificates for SSL client authentication.
#
# $ssl_key::                  Location of the SSL key file.
#
# $ssl_ca::                   Location of the SSL CA file
#
# $ssl_chain::                Location of the SSL chain file
#
# $ssl_crl::                  Location of the SSL certificate revocation list file
#
# $ssl_protocol::             SSLProtocol configuration to use
#
# $user::                     The user under which the application runs.
#
# $passenger_prestart::       Pre-start the first passenger worker instance process during httpd start.
#
# $passenger_min_instances::  Minimum passenger worker instances to keep when application is idle.
#
# $passenger_start_timeout::  Amount of seconds to wait for Ruby application boot.
#
# $foreman_url::              The URL Foreman should be reachable under. Used for loading the application
#                             on startup rather than on demand.
#
# $access_log_format::        Apache log format to use
#
# $ipa_authentication::       Whether to install support for IPA authentication
#
# === Advanced options:
#
# $http_vhost_options::       Direct options to apache::vhost for the http vhost
#
# $https_vhost_options::      Direct options to apache::vhost for the https vhost
#
class foreman::config::apache(
  Boolean $passenger = $::foreman::passenger,
  Stdlib::Absolutepath $app_root = $::foreman::app_root,
  Optional[String] $passenger_ruby = $::foreman::passenger_ruby,
  String $priority = $::foreman::vhost_priority,
  Stdlib::Fqdn $servername = $::foreman::servername,
  Array[Stdlib::Fqdn] $serveraliases = $::foreman::serveraliases,
  Stdlib::Port $server_port = $::foreman::server_port,
  Stdlib::Port $server_ssl_port = $::foreman::server_ssl_port,
  Stdlib::Httpurl $proxy_backend = "http://${::foreman::foreman_service_bind}:${::foreman::foreman_service_port}/",
  Hash $proxy_params = {'retry' => '0'},
  Array[String] $proxy_no_proxy_uris = ['/pulp', '/streamer', '/pub'],
  Boolean $ssl = $::foreman::ssl,
  Stdlib::Absolutepath $ssl_ca = $::foreman::server_ssl_ca,
  Stdlib::Absolutepath $ssl_chain = $::foreman::server_ssl_chain,
  Stdlib::Absolutepath $ssl_cert = $::foreman::server_ssl_cert,
  Variant[Enum[''], Stdlib::Absolutepath] $ssl_certs_dir = $::foreman::server_ssl_certs_dir,
  Stdlib::Absolutepath $ssl_key = $::foreman::server_ssl_key,
  Variant[Enum[''], Stdlib::Absolutepath] $ssl_crl = $::foreman::server_ssl_crl,
  Optional[String] $ssl_protocol = $::foreman::server_ssl_protocol,
  Enum['none','optional','require','optional_no_ca'] $ssl_verify_client = $::foreman::server_ssl_verify_client,
  String $user = $::foreman::user,
  Boolean $passenger_prestart = $::foreman::passenger_prestart,
  Integer[0] $passenger_min_instances = $::foreman::passenger_min_instances,
  Integer[0] $passenger_start_timeout = $::foreman::passenger_start_timeout,
  Stdlib::HTTPUrl $foreman_url = $::foreman::foreman_url,
  Optional[String] $access_log_format = undef,
  Boolean $ipa_authentication = $::foreman::ipa_authentication,
  Hash[String, Any] $http_vhost_options = {},
  Hash[String, Any] $https_vhost_options = {},
) {
  $docroot = "${app_root}/public"
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

  if $passenger {
    if $suburi {
      $custom_fragment = template('foreman/_suburi.conf.erb')
    } else {
      $custom_fragment = template('foreman/_assets.conf.erb')
    }

    $passenger_options = {
      'passenger_app_root' => $app_root,
      'passenger_min_instances' => $passenger_min_instances,
      'passenger_start_timeout' => $passenger_start_timeout,
      'passenger_ruby' => $passenger_ruby,
    }

    if $passenger_prestart {
      $vhost_http_internal_options = $passenger_options + {'passenger_pre_start' => "http://${servername}:${server_port}"}
      $vhost_https_internal_options = $passenger_options + {'passenger_pre_start' => "https://${servername}:${server_ssl_port}"}
    } else {
      $vhost_http_internal_options = $passenger_options
      $vhost_https_internal_options = $passenger_options
    }

    if $app_root {
      file { ["${app_root}/config.ru", "${app_root}/config/environment.rb"]:
        owner => $user,
      }
    }
  } else {
    if $suburi {
      $custom_fragment = undef
    } else {
      $custom_fragment = template('foreman/_assets.conf.erb')
    }

    include ::apache::mod::proxy_wstunnel
    $websockets_backend = regsubst($proxy_backend, 'http://', 'ws://')

    $vhost_http_internal_options = {
      'proxy_preserve_host' => true,
      'proxy_add_headers'   => true,
      'request_headers'     => [
        'set X_FORWARDED_PROTO "http"',
        'set SSL_CLIENT_S_DN ""',
        'set SSL_CLIENT_CERT ""',
        'set SSL_CLIENT_VERIFY ""',
      ],
      'proxy_pass'          => {
        'no_proxy_uris' => $proxy_no_proxy_uris,
        'path'          => pick($suburi, '/'),
        'url'           => $proxy_backend,
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

    $vhost_https_internal_options = $vhost_http_internal_options + {
      'ssl_proxyengine' => true,
      'request_headers' => [
        'set X_FORWARDED_PROTO "https"',
        'set SSL_CLIENT_S_DN "%{SSL_CLIENT_S_DN}s"',
        'set SSL_CLIENT_CERT "%{SSL_CLIENT_CERT}s"',
        'set SSL_CLIENT_VERIFY "%{SSL_CLIENT_VERIFY}s"',
      ],
    }

    if $facts['selinux'] {
      selboolean { 'httpd_can_network_connect':
        persistent => true,
        value      => 'on',
      }
    }
  }

  include ::apache
  include ::apache::mod::headers

  if $ipa_authentication {
    include ::apache::mod::authnz_pam
    include ::apache::mod::intercept_form_submit
    include ::apache::mod::lookup_identity
    include ::apache::mod::auth_kerb
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
    additional_includes   => ["${::apache::confd_dir}/${priority}-foreman.d/*.conf"],
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
      ssl_certs_dir         => $ssl_certs_dir,
      ssl_key               => $ssl_key,
      ssl_chain             => $ssl_chain,
      ssl_ca                => $ssl_ca,
      ssl_crl               => $ssl_crl_real,
      ssl_crl_check         => $ssl_crl_check,
      ssl_protocol          => $ssl_protocol,
      ssl_verify_client     => $ssl_verify_client,
      ssl_options           => '+StdEnvVars +ExportCertData',
      ssl_verify_depth      => '3',
      access_log_format     => $access_log_format,
      additional_includes   => ["${::apache::confd_dir}/${priority}-foreman-ssl.d/*.conf"],
      use_optional_includes => true,
      custom_fragment       => $custom_fragment,
      *                     => $vhost_https_internal_options + $https_vhost_options,
    }
  }
}
