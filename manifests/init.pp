# Manage your foreman server
#
# === Parameters:
#
# $initial_admin_username::       Initial username for the admin user account, default is admin
#
# $initial_admin_password::       Initial password of the admin user, default is randomly generated
#
# $initial_admin_first_name::     Initial first name of the admin user
#
# $initial_admin_last_name::      Initial last name of the admin user
#
# $initial_admin_email::          Initial E-mail address of the admin user
#
# $initial_admin_locale::         Initial locale (= language) of the admin user
#
# $initial_admin_timezone::       Initial timezone of the admin user
#
# $db_manage::                    If enabled, will install and configure the database server on this host
#
# $email_delivery_method::        Email delivery method
#
# $email_sendmail_location::      The location of the binary to call when sendmail is the delivery method. Unused when SMTP delivery is used.
#
# $email_sendmail_arguments::     The arguments to pass to the sendmail binary. Unused when SMTP delivery is used.
#
# $email_smtp_address::           SMTP server hostname, when delivery method is SMTP
#
# $email_smtp_port::              SMTP port
#
# $email_smtp_domain::            SMTP HELO domain
#
# $email_smtp_authentication::    SMTP authentication method
#
# $email_smtp_user_name::         Username for SMTP server auth, if authentication is enabled
#
# $email_smtp_password::          Password for SMTP server auth, if authentication is enabled
#
# $email_reply_address::          Email reply address for emails that Foreman is sending
#
# $email_subject_prefix::         Prefix to add to all outgoing email
#
# $initial_organization::         Name of an initial organization
#
# $initial_location::             Name of an initial location
#
# $ipa_authentication::           Enable configuration for external authentication via IPA
#
# $ipa_authentication_api::       Enable configuration for external authentication via IPA for API
#
# === Advanced parameters:
#
# $foreman_url::                  URL on which foreman is going to run
#
# $unattended::                   Should Foreman manage host provisioning as well
#
# $unattended_url::               URL hosts will retrieve templates from during build (normally http as many installers don't support https)
#
# $apache::                       Configure Apache as a reverse proxy for the Foreman server
#
# $servername::                   Server name of the VirtualHost in the webserver
#
# $serveraliases::                Server aliases of the VirtualHost in the webserver
#
# $ssl::                          Enable and set require_ssl in Foreman settings (note: requires Apache, SSL does not apply to kickstarts)
#
# $version::                      Foreman package version, it's passed to ensure parameter of package resource
#                                 can be set to specific version number, 'latest', 'present' etc.
#
# $plugin_version::               Foreman plugins package version, it's passed to ensure parameter of package resource
#                                 can be set to 'installed', 'latest', 'present' only
#
# $db_host::                      Database 'production' host
#
# $db_port::                      Database 'production' port
#
# $db_database::                  Database 'production' database (e.g. foreman)
#
# $db_username::                  Database 'production' user (e.g. foreman)
#
# $db_password::                  Database 'production' password, default is randomly generated
#
# $db_sslmode::                   Database 'production' ssl mode
#
# $db_root_cert::                 Root cert used to verify SSL connection to postgres
#
# $db_pool::                      Database 'production' size of connection pool. If the value is not set, it will be
#                                 set by default to the amount of puma threads + 4 (for internal system threads)
#
# $db_manage_rake::               if enabled, will run rake jobs, which depend on the database
#
# $server_port::                  Defines Apache port for HTTP requests
#
# $server_ssl_port::              Defines Apache port for HTTPS requests
#
# $server_ssl_ca::                Defines Apache mod_ssl SSLCACertificateFile setting in Foreman vhost conf file.
#
# $server_ssl_chain::             Defines Apache mod_ssl SSLCertificateChainFile setting in Foreman vhost conf file.
#
# $server_ssl_cert::              Defines Apache mod_ssl SSLCertificateFile setting in Foreman vhost conf file.
#
# $server_ssl_key::               Defines Apache mod_ssl SSLCertificateKeyFile setting in Foreman vhost conf file.
#
# $server_ssl_crl::               Defines the Apache mod_ssl SSLCARevocationFile setting in Foreman vhost conf file.
#
# $server_ssl_protocol::          Defines the Apache mod_ssl SSLProtocol setting in Foreman vhost conf file.
#
# $server_ssl_verify_client::     Defines the Apache mod_ssl SSLVerifyClient setting in Foreman vhost conf file.
#
# $client_ssl_ca::                Defines the SSL CA used to communicate with Foreman Proxies
#
# $client_ssl_cert::              Defines the SSL certificate used to communicate with Foreman Proxies
#
# $client_ssl_key::               Defines the SSL private key used to communicate with Foreman Proxies
#
# $oauth_active::                 Enable OAuth authentication for REST API
#
# $oauth_map_users::              Should Foreman use the foreman_user header to identify API user?
#
# $oauth_consumer_key::           OAuth consumer key
#
# $oauth_consumer_secret::        OAuth consumer secret
#
# $oauth_effective_user::         User to be used for REST interaction
#
# $http_keytab::                  Path to keytab to be used for Kerberos authentication on the WebUI. If left empty, it will be automatically determined.
#
# $gssapi_local_name::            Whether to enable GssapiLocalName when using mod_auth_gssapi
#
# $pam_service::                  PAM service used for host-based access control in IPA
#
# $ipa_manage_sssd::              If ipa_authentication is true, should the installer manage SSSD? You can disable it
#                                 if you use another module for SSSD configuration
#
# $ipa_sssd_default_realm::       If ipa_manage_sssd is true, set default_domain_suffix option in sssd configuration to this value
#                                 to allow logging in without having to provide the domain name.
#
# $websockets_encrypt::           Whether to encrypt websocket connections
#
# $websockets_ssl_key::           SSL key file to use when encrypting websocket connections
#
# $websockets_ssl_cert::          SSL certificate file to use when encrypting websocket connections
#
# $logging_level::                Logging level of the Foreman application
#
# $logging_type::                 Logging type of the Foreman application
#
# $logging_layout::               Logging layout of the Foreman application
#
# $loggers::                      Enable or disable specific loggers, e.g. {"sql" => true}
#
# $telemetry_prefix::             Prefix for all metrics
#
# $telemetry_prometheus_enabled:: Enable prometheus telemetry
#
# $telemetry_statsd_enabled::     Enable statsd telemetry
#
# $telemetry_statsd_host::        Statsd host in format ip:port, do not use DNS
#
# $telemetry_statsd_protocol::    Statsd protocol one of 'statsd', 'statsite' or 'datadog' - currently only statsd is supported
#
# $telemetry_logger_enabled::     Enable telemetry logs - useful for telemetry debugging
#
# $telemetry_logger_level::       Telemetry debugging logs level
#
# $hsts_enabled::                 Should HSTS enforcement in https requests be enabled
#
# $cors_domains::                 List of domains that show be allowed for Cross-Origin Resource Sharing
#
# $trusted_proxies::              List of trusted IPs / networks. Default: IPv4 and IPV6 localhost addresses.
#                                 If overwritten, localhost addresses (127.0.0.1/8, ::1) need to be in trusted_proxies IP list again.
#                                 More details: https://api.rubyonrails.org/classes/ActionDispatch/RemoteIp.html
#
# $foreman_service_puma_threads_min::     Minimum number of threads for every Puma worker. If no value is specified, this defaults
#                                         to setting min threads to maximum threads. Setting min threads equal to max threads has
#                                         been shown to alleviate memory leaks and in some cases produce better performance.
#
# $foreman_service_puma_threads_max::     Maximum number of threads for every Puma worker
#
# $foreman_service_puma_workers::         Number of workers for Puma.
#                                         If not set, the value is dynamically calculated based on available number of
#                                         CPUs and memory.
#
# $rails_cache_store::            Set rails cache store
#
# $register_in_foreman::          Register host in Foreman
#
# $provisioning_ct_location::     The location of the binary to call when transpiling CoreOS templates.
#
# $provisioning_fcct_location::   The location of the binary to call when transpiling Fedora CoreOS templates.
#
# === Dynflow parameters:
#
# $dynflow_manage_services::      Whether to manage the dynflow services
#
# $dynflow_orchestrator_ensure::  The state of the dynflow orchestrator instance
#
# $dynflow_worker_instances::     The number of worker instances that should be running
#
# $dynflow_worker_concurrency::   How many concurrent jobs to handle per worker instance
#
# $dynflow_redis_url::            If set, the redis server is not managed and we use the defined url to connect
#
# === Keycloak parameters:
#
# $keycloak::                     Enable Keycloak support. Note this is limited
#                                 to configuring Apache and still relies on manually
#                                 running keycloak-httpd-client-install
#
# $keycloak_app_name::            The app name as passed to keycloak-httpd-client-install
#
# $keycloak_realm::               The realm as passed to keycloak-httpd-client-install
#
# === OIDC parameters:
#
# $authorize_login_delegation::   Authorize login delegation with REMOTE_USER HTTP header (true/false)
#
# $authorize_login_delegation_auth_source_user_autocreate::   Name of the external auth source where unknown externally authentication
#                                                             users (see authorize_login_delegation) should be created. Empty means no autocreation.
#
# $login_delegation_logout_url::  Redirect your users to this url on logout (authorize_login_delegation should also be enabled)
#
# $oidc_jwks_url::                OpenID Connect JSON Web Key Set(JWKS) URL.
#                                 Typically https://keycloak.example.com/auth/realms/<realm name>/protocol/openid-connect/certs when using
#                                 Keycloak as an OpenID provider
#
# $oidc_audience::                Name of the OpenID Connect Audience that is being used for Authentication. In case of Keycloak this is the Client ID.
#                                 ['oidc_app_name']
#
# $oidc_issuer::                  The iss (issuer) claim identifies the principal that issued the JWT, which exists at a
#                                 `/.well-known/openid-configuration` in case of most of the OpenID providers.
#
# $oidc_algorithm::               The algorithm used to encode the JWT in the OpenID provider.
#
# $outofsync_interval   Duration in minutes after servers are classed as out of sync.
#
#
class foreman (
  Stdlib::HTTPUrl $foreman_url = $foreman::params::foreman_url,
  Boolean $unattended = true,
  Optional[Stdlib::HTTPUrl] $unattended_url = undef,
  Boolean $apache = true,
  Stdlib::Fqdn $servername = $foreman::params::servername,
  Array[Stdlib::Fqdn] $serveraliases = ['foreman'],
  Boolean $ssl = true,
  String $version = 'present',
  Enum['installed', 'present', 'latest'] $plugin_version = 'present',
  Boolean $db_manage = true,
  Optional[Stdlib::Host] $db_host = undef,
  Optional[Stdlib::Port] $db_port = undef,
  String[1] $db_database = 'foreman',
  String[1] $db_username = 'foreman',
  String[1] $db_password = $foreman::params::db_password,
  Optional[String[1]] $db_sslmode = undef,
  Optional[String[1]] $db_root_cert = undef,
  Optional[Integer[0]] $db_pool = undef,
  Boolean $db_manage_rake = true,
  Stdlib::Port $server_port = 80,
  Stdlib::Port $server_ssl_port = 443,
  Stdlib::Absolutepath $server_ssl_ca = $foreman::params::server_ssl_ca,
  Stdlib::Absolutepath $server_ssl_chain = $foreman::params::server_ssl_chain,
  Stdlib::Absolutepath $server_ssl_cert = $foreman::params::server_ssl_cert,
  Stdlib::Absolutepath $server_ssl_key = $foreman::params::server_ssl_key,
  Variant[Enum[''], Stdlib::Absolutepath] $server_ssl_crl = $foreman::params::server_ssl_crl,
  Optional[String] $server_ssl_protocol = undef,
  Enum['none','optional','require','optional_no_ca'] $server_ssl_verify_client = 'optional',
  Stdlib::Absolutepath $client_ssl_ca = $foreman::params::client_ssl_ca,
  Stdlib::Absolutepath $client_ssl_cert = $foreman::params::client_ssl_cert,
  Stdlib::Absolutepath $client_ssl_key = $foreman::params::client_ssl_key,
  Boolean $oauth_active = true,
  Boolean $oauth_map_users = false,
  String $oauth_consumer_key = $foreman::params::oauth_consumer_key,
  String $oauth_consumer_secret = $foreman::params::oauth_consumer_secret,
  String $oauth_effective_user = $foreman::params::oauth_effective_user,
  String $initial_admin_username = 'admin',
  String $initial_admin_password = $foreman::params::initial_admin_password,
  Optional[String] $initial_admin_first_name = undef,
  Optional[String] $initial_admin_last_name = undef,
  Optional[String] $initial_admin_email = undef,
  Optional[String] $initial_admin_locale = undef,
  Optional[String] $initial_admin_timezone = undef,
  Optional[String] $initial_organization = undef,
  Optional[String] $initial_location = undef,
  Boolean $ipa_authentication = false,
  Boolean $ipa_authentication_api = false,
  Optional[Stdlib::Absolutepath] $http_keytab = undef,
  Boolean $gssapi_local_name = true,
  String $pam_service = 'foreman',
  Boolean $ipa_manage_sssd = true,
  Optional[String] $ipa_sssd_default_realm = undef,
  Boolean $websockets_encrypt = true,
  Optional[Stdlib::Absolutepath] $websockets_ssl_key = undef,
  Optional[Stdlib::Absolutepath] $websockets_ssl_cert = undef,
  Enum['debug', 'info', 'warn', 'error', 'fatal'] $logging_level = 'info',
  Enum['file', 'syslog', 'journald'] $logging_type = 'file',
  Optional[Enum['pattern', 'multiline_pattern', 'multiline_request_pattern', 'json']] $logging_layout = undef,
  Hash[String, Boolean] $loggers = {},
  Optional[Enum['sendmail', 'smtp']] $email_delivery_method = undef,
  Optional[Stdlib::Absolutepath] $email_sendmail_location = undef,
  Optional[String[1]] $email_sendmail_arguments = undef,
  Optional[Stdlib::Host] $email_smtp_address = undef,
  Stdlib::Port $email_smtp_port = 25,
  Optional[Stdlib::Fqdn] $email_smtp_domain = undef,
  Enum['none', 'plain', 'login', 'cram-md5'] $email_smtp_authentication = 'none',
  Optional[String] $email_smtp_user_name = undef,
  Optional[String] $email_smtp_password = undef,
  Optional[String] $email_reply_address = undef,
  Optional[String] $email_subject_prefix = undef,
  String $telemetry_prefix = 'fm_rails',
  Boolean $telemetry_prometheus_enabled = false,
  Boolean $telemetry_statsd_enabled = false,
  String $telemetry_statsd_host = '127.0.0.1:8125',
  Enum['statsd', 'statsite', 'datadog'] $telemetry_statsd_protocol = 'statsd',
  Boolean $telemetry_logger_enabled = false,
  Enum['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'] $telemetry_logger_level = 'DEBUG',
  Boolean $dynflow_manage_services = true,
  Enum['present', 'absent'] $dynflow_orchestrator_ensure = 'present',
  Integer[0] $dynflow_worker_instances = 1,
  Integer[0] $dynflow_worker_concurrency = 5,
  Optional[Redis::RedisUrl] $dynflow_redis_url = undef,
  Boolean $hsts_enabled = true,
  Array[Stdlib::HTTPUrl] $cors_domains = [],
  Array[String[1]] $trusted_proxies = [],
  Optional[Integer[0]] $foreman_service_puma_threads_min = undef,
  Integer[0] $foreman_service_puma_threads_max = 5,
  Optional[Integer[0]] $foreman_service_puma_workers = undef,
  Hash[String, Any] $rails_cache_store = { 'type' => 'redis' },
  Boolean $keycloak = false,
  String[1] $keycloak_app_name = 'foreman-openidc',
  String[1] $keycloak_realm = 'ssl-realm',
  Boolean $register_in_foreman = true,
  Optional[Stdlib::Absolutepath] $provisioning_ct_location = undef,
  Optional[Stdlib::Absolutepath] $provisioning_fcct_location = undef,
  Boolean $authorize_login_delegation = false,
  String[1] $authorize_login_delegation_auth_source_user_autocreate = 'External',
  Optional[String[1]] $login_delegation_logout_url = undef,
  Optional[String[1]] $oidc_jwks_url = undef,
  Array[String[1]] $oidc_audience = [],
  Optional[String[1]] $oidc_issuer = undef,
  String[1] $oidc_algorithm = 'RS256',
  Integer $outofsync_interval = 30,
) inherits foreman::params {
  assert_type(Array[Stdlib::IP::Address], $trusted_proxies)

  if !$db_sslmode and $db_root_cert {
    $db_sslmode_real = 'verify-full'
  } else {
    $db_sslmode_real = $db_sslmode
  }

  include foreman::install
  include foreman::config
  include foreman::database
  contain foreman::service

  Anchor <| title == 'foreman::repo' |> ~> Class['foreman::install']
  Class['foreman::install'] ~> Class['foreman::config', 'foreman::service']
  Class['foreman::config'] ~> Class['foreman::database', 'foreman::service']
  Class['foreman::database'] ~> Class['foreman::service']
  Class['foreman::service'] -> Foreman_smartproxy <| base_url == $foreman_url |>
  anchor { 'foreman::service': } # lint:ignore:anchor_resource
  Class['foreman::service'] -> Anchor['foreman::service']

  if $apache {
    Class['foreman::database'] -> Class['apache::service']
    if $ipa_authentication and $keycloak {
      fail("${facts['networking']['hostname']}: External authentication via IPA and Keycloak are mutually exclusive.")
    }
    if !$ipa_authentication and $ipa_authentication_api {
      fail("${facts['networking']['hostname']}: External authentication for API via IPA requires general external authentication to be enabled.")
    }
  } elsif $ipa_authentication {
    fail("${facts['networking']['hostname']}: External authentication via IPA can only be enabled when Apache is used.")
  } elsif $keycloak {
    fail("${facts['networking']['hostname']}: External authentication via Keycloak can only be enabled when Apache is used.")
  }

  if $foreman::register_in_foreman {
    include foreman::register
  }

  # Anchor these separately so as not to break
  # the notify between main classes
  Class['foreman::install']
  ~> Package <| tag == 'foreman-compute' |>
  ~> Class['foreman::service']

  Package <| tag == 'foreman::cli' |> -> Class['foreman']
  Package <| tag == 'foreman::providers' |> -> Class['foreman']

  contain 'foreman::settings' # lint:ignore:relative_classname_inclusion (PUP-1597)
  Class['foreman::database'] -> Class['foreman::settings']

  file { '/usr/share/foreman/tmp/restart_required_changed_plugins':
    ensure  => absent,
    notify  => Class['foreman::service'],
    require => Class['foreman::install'],
  }
}
