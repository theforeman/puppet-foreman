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
# $initial_organization::         Name of an initial organization
#
# $initial_location::             Name of an initial location
#
# $ipa_authentication::           Enable configuration for external authentication via IPA
#
# === Advanced parameters:
#
# $foreman_url::                  URL on which foreman is going to run
#
# $unattended::                   Should Foreman manage host provisioning as well
#
# $unattended_url::               URL hosts will retrieve templates from during build (normally http as many installers don't support https)
#
# $apache::                       Configure Foreman via Apache. By default via passenger but otherwise as a reverse proxy.
#
# $passenger::                    Whether to configure Apache with passenger or as a reverse proxy.
#
# $passenger_ruby::               Ruby interpreter used to run Foreman under Passenger
#
# $passenger_ruby_package::       Package to install to provide Passenger libraries for the active Ruby
#                                 interpreter
#
# $plugin_prefix::                String which is prepended to the plugin package names
#
# $servername::                   Server name of the VirtualHost in the webserver
#
# $serveraliases::                Server aliases of the VirtualHost in the webserver
#
# $ssl::                          Enable and set require_ssl in Foreman settings (note: requires passenger, SSL does not apply to kickstarts)
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
# $db_pool::                      Database 'production' size of connection pool
#
# $db_manage_rake::               if enabled, will run rake jobs, which depend on the database
#
# $app_root::                     Name of foreman root directory
#
# $manage_user::                  Controls whether foreman module will manage the user on the system.
#
# $user::                         User under which foreman will run
#
# $group::                        Primary group for the Foreman user
#
# $rails_env::                    Rails environment of foreman
#
# $user_groups::                  Additional groups for the Foreman user
#
# $passenger_prestart::           Pre-start the first passenger worker instance process during httpd start.
#
# $passenger_min_instances::      Minimum passenger worker instances to keep when application is idle.
#
# $passenger_start_timeout::      Number of seconds to wait for Ruby application boot.
#
# $vhost_priority::               Defines Apache vhost priority for the Foreman vhost conf file.
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
# $server_ssl_certs_dir::         Defines Apache mod_ssl SSLCACertificatePath setting in Foreman vhost conf file.
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
# $http_keytab::                  Path to keytab to be used for Kerberos authentication on the WebUI
#
# $pam_service::                  PAM service used for host-based access control in IPA
#
# $ipa_manage_sssd::              If ipa_authentication is true, should the installer manage SSSD? You can disable it
#                                 if you use another module for SSSD configuration
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
# $dynflow_pool_size::            How many threads per worker process should Dynflow use
#
# $jobs_manage_service::          Whether to manage the dynflow services
#
# $jobs_service_enable::          Whether the Dynflow executor should be enabled
#
# $jobs_service_ensure::          Whether the Dynflow executor should be running or stopped
#
# $jobs_sidekiq_redis_url::       If set, the redis server is not managed and we use the defined url to connect
#
# $hsts_enabled::                 Should HSTS enforcement in https requests be enabled
#
# $cors_domains::                 List of domains that show be allowed for Cross-Origin Resource Sharing. This requires Foreman 1.22+
#
# $foreman_service_puma_threads_min::     Minimum number of threads for Puma. Relevant only when Puma service is used and ignored when Passenger is used.
#
# $foreman_service_puma_threads_max::     Maximum number of threads for Puma. Relevant only when Puma service is used and ignored when Passenger is used.
#
# $foreman_service_puma_workers::         Number of workers for Puma. Relevant only when Puma service is used and ignored when Passenger is used.
#
# $rails_cache_store::            Set rails cache store
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
class foreman (
  Stdlib::HTTPUrl $foreman_url = $foreman::params::foreman_url,
  Boolean $unattended = $foreman::params::unattended,
  Optional[Stdlib::HTTPUrl] $unattended_url = $foreman::params::unattended_url,
  Boolean $apache = $foreman::params::apache,
  Boolean $passenger = $foreman::params::passenger,
  Optional[String] $passenger_ruby = $foreman::params::passenger_ruby,
  Optional[String] $passenger_ruby_package = $foreman::params::passenger_ruby_package,
  String $plugin_prefix = $foreman::params::plugin_prefix,
  Stdlib::Fqdn $servername = $foreman::params::servername,
  Array[Stdlib::Fqdn] $serveraliases = $foreman::params::serveraliases,
  Boolean $ssl = $foreman::params::ssl,
  String $version = $foreman::params::version,
  Enum['installed', 'present', 'latest'] $plugin_version = $foreman::params::plugin_version,
  Boolean $db_manage = $foreman::params::db_manage,
  Optional[Stdlib::Host] $db_host = 'UNSET',
  Variant[Undef, Enum['UNSET'], Stdlib::Port] $db_port = 'UNSET',
  Optional[String] $db_database = 'UNSET',
  Optional[String] $db_username = $foreman::params::db_username,
  Optional[String] $db_password = $foreman::params::db_password,
  Optional[String] $db_sslmode = 'UNSET',
  Optional[String] $db_root_cert = undef,
  Integer[0] $db_pool = $foreman::params::db_pool,
  Boolean $db_manage_rake = $foreman::params::db_manage_rake,
  Stdlib::Absolutepath $app_root = $foreman::params::app_root,
  Boolean $manage_user = $foreman::params::manage_user,
  String $user = $foreman::params::user,
  String $group = $foreman::params::group,
  Array[String] $user_groups = $foreman::params::user_groups,
  String $rails_env = $foreman::params::rails_env,
  String $vhost_priority = $foreman::params::vhost_priority,
  Stdlib::Port $server_port = $foreman::params::server_port,
  Stdlib::Port $server_ssl_port = $foreman::params::server_ssl_port,
  Stdlib::Absolutepath $server_ssl_ca = $foreman::params::server_ssl_ca,
  Stdlib::Absolutepath $server_ssl_chain = $foreman::params::server_ssl_chain,
  Stdlib::Absolutepath $server_ssl_cert = $foreman::params::server_ssl_cert,
  Variant[Enum[''], Stdlib::Absolutepath] $server_ssl_certs_dir = $foreman::params::server_ssl_certs_dir,
  Stdlib::Absolutepath $server_ssl_key = $foreman::params::server_ssl_key,
  Variant[Enum[''], Stdlib::Absolutepath] $server_ssl_crl = $foreman::params::server_ssl_crl,
  Optional[String] $server_ssl_protocol = $foreman::params::server_ssl_protocol,
  Enum['none','optional','require','optional_no_ca'] $server_ssl_verify_client = $foreman::params::server_ssl_verify_client,
  Stdlib::Absolutepath $client_ssl_ca = $foreman::params::client_ssl_ca,
  Stdlib::Absolutepath $client_ssl_cert = $foreman::params::client_ssl_cert,
  Stdlib::Absolutepath $client_ssl_key = $foreman::params::client_ssl_key,
  Boolean $oauth_active = $foreman::params::oauth_active,
  Boolean $oauth_map_users = $foreman::params::oauth_map_users,
  String $oauth_consumer_key = $foreman::params::oauth_consumer_key,
  String $oauth_consumer_secret = $foreman::params::oauth_consumer_secret,
  Boolean $passenger_prestart = $foreman::params::passenger_prestart,
  Integer[0] $passenger_min_instances = $foreman::params::passenger_min_instances,
  Integer[0] $passenger_start_timeout = $foreman::params::passenger_start_timeout,
  String $initial_admin_username = $foreman::params::initial_admin_username,
  String $initial_admin_password = $foreman::params::initial_admin_password,
  Optional[String] $initial_admin_first_name = $foreman::params::initial_admin_first_name,
  Optional[String] $initial_admin_last_name = $foreman::params::initial_admin_last_name,
  Optional[String] $initial_admin_email = $foreman::params::initial_admin_email,
  Optional[String] $initial_admin_locale = $foreman::params::initial_admin_locale,
  Optional[String] $initial_admin_timezone = $foreman::params::initial_admin_timezone,
  Optional[String] $initial_organization = $foreman::params::initial_organization,
  Optional[String] $initial_location = $foreman::params::initial_location,
  Boolean $ipa_authentication = $foreman::params::ipa_authentication,
  Stdlib::Absolutepath $http_keytab = $foreman::params::http_keytab,
  String $pam_service = $foreman::params::pam_service,
  Boolean $ipa_manage_sssd = $foreman::params::ipa_manage_sssd,
  Boolean $websockets_encrypt = $foreman::params::websockets_encrypt,
  Optional[Stdlib::Absolutepath] $websockets_ssl_key = $foreman::params::websockets_ssl_key,
  Optional[Stdlib::Absolutepath] $websockets_ssl_cert = $foreman::params::websockets_ssl_cert,
  Enum['debug', 'info', 'warn', 'error', 'fatal'] $logging_level = $foreman::params::logging_level,
  Enum['file', 'syslog', 'journald'] $logging_type = $foreman::params::logging_type,
  Enum['pattern', 'multiline_pattern', 'json'] $logging_layout = $foreman::params::logging_layout,
  Hash[String, Boolean] $loggers = $foreman::params::loggers,
  Optional[Enum['sendmail', 'smtp']] $email_delivery_method = $foreman::params::email_delivery_method,
  Optional[Stdlib::Host] $email_smtp_address = $foreman::params::email_smtp_address,
  Stdlib::Port $email_smtp_port = $foreman::params::email_smtp_port,
  Optional[Stdlib::Fqdn] $email_smtp_domain = $foreman::params::email_smtp_domain,
  Enum['none', 'plain', 'login', 'cram-md5'] $email_smtp_authentication = $foreman::params::email_smtp_authentication,
  Optional[String] $email_smtp_user_name = $foreman::params::email_smtp_user_name,
  Optional[String] $email_smtp_password = $foreman::params::email_smtp_password,
  String $telemetry_prefix = $foreman::params::telemetry_prefix,
  Boolean $telemetry_prometheus_enabled = $foreman::params::telemetry_prometheus_enabled,
  Boolean $telemetry_statsd_enabled = $foreman::params::telemetry_statsd_enabled,
  String $telemetry_statsd_host = $foreman::params::telemetry_statsd_host,
  Enum['statsd', 'statsite', 'datadog'] $telemetry_statsd_protocol = $foreman::params::telemetry_statsd_protocol,
  Boolean $telemetry_logger_enabled = $foreman::params::telemetry_logger_enabled,
  Enum['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'] $telemetry_logger_level = $foreman::params::telemetry_logger_level,
  Stdlib::Port $dynflow_pool_size = $foreman::params::dynflow_pool_size,
  Boolean $jobs_manage_service = $foreman::params::jobs_manage_service,
  Stdlib::Ensure::Service $jobs_service_ensure = $foreman::params::jobs_service_ensure,
  Boolean $jobs_service_enable = $foreman::params::jobs_service_enable,
  Optional[Redis::RedisUrl] $jobs_sidekiq_redis_url = $foreman::params::jobs_sidekiq_redis_url,
  Boolean $hsts_enabled = $foreman::params::hsts_enabled,
  Array[Stdlib::HTTPUrl] $cors_domains = $foreman::params::cors_domains,
  Integer[0] $foreman_service_puma_threads_min = $foreman::params::foreman_service_puma_threads_min,
  Integer[0] $foreman_service_puma_threads_max = $foreman::params::foreman_service_puma_threads_max,
  Integer[0] $foreman_service_puma_workers = $foreman::params::foreman_service_puma_workers,
  Hash[String, Any] $rails_cache_store = $foreman::params::rails_cache_store,
  Boolean $keycloak = $foreman::params::keycloak,
  String[1] $keycloak_app_name = $foreman::params::keycloak_app_name,
  String[1] $keycloak_realm = $foreman::params::keycloak_realm,
) inherits foreman::params {
  if $db_sslmode == 'UNSET' and $db_root_cert {
    $db_sslmode_real = 'verify-full'
  } else {
    $db_sslmode_real = $db_sslmode
  }

  foreman::rake { 'apipie:cache:index':
    timeout => 0,
  }

  if $apache {
    $use_foreman_service = ! $passenger
    $foreman_service_bind = '127.0.0.1'
  } else {
    $use_foreman_service = true
    $foreman_service_bind = '0.0.0.0'
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

  if $apache {
    Class['foreman::database'] -> Class['apache::service']
    if $ipa_authentication and $keycloak {
      fail("${facts['networking']['hostname']}: External authentication via IPA and Keycloak are mutually exclusive.")
    }
  } elsif $ipa_authentication {
    fail("${facts['networking']['hostname']}: External authentication via IPA can only be enabled when Apache is used.")
  } elsif $keycloak {
    fail("${facts['networking']['hostname']}: External authentication via Keycloak can only be enabled when Apache is used.")
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
}
