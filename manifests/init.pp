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
# $db_manage::                    If enabled, will install and configure the database server on this host
#
# $db_type::                      Database 'production' type
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
# $repo::                         This can be a specific version or nightly
#
# $configure_epel_repo::          If disabled the EPEL repo will not be configured on Red Hat family systems.
#
# $configure_scl_repo::           If disabled the SCL repo will not be configured on Red Hat clone systems.
#                                 (Currently only installs repos for CentOS and Scientific)
#
# $selinux::                      When undef, foreman-selinux will be installed if SELinux is enabled
#                                 setting to false/true will override this check (e.g. set to false on 1.1)
#
# $gpgcheck::                     Turn on/off gpg check in repo files (effective only on RedHat family systems)
#
# $version::                      Foreman package version, it's passed to ensure parameter of package resource
#                                 can be set to specific version number, 'latest', 'present' etc.
#
# $plugin_version::               Foreman plugins package version, it's passed to ensure parameter of package resource
#                                 can be set to 'installed', 'latest', 'present' only
#
# $db_adapter::                   Database 'production' adapter
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
# $passenger_interface::          Defines which network interface passenger should listen on, undef means all interfaces
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
# $client_ssl_ca::                Defines the SSL CA used to communicate with Foreman Proxies
#
# $client_ssl_cert::              Defines the SSL certificate used to communicate with Foreman Proxies
#
# $client_ssl_key::               Defines the SSL private key used to communicate with Foreman Proxies
#
# $keepalive::                    Enable KeepAlive setting of Apache?
#
# $max_keepalive_requests::       MaxKeepAliveRequests setting of Apache
#                                 (Number of requests allowed on a persistent connection)
#
# $keepalive_timeout::            KeepAliveTimeout setting of Apache
#                                 (Seconds the server will wait for subsequent requests on a persistent connection)
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
# $dynflow_pool_size::            How many workers should Dynflow use
#
# $jobs_service::                 Name of the service for running the background Dynflow executor
#
# $jobs_service_enable::          Whether the Dynflow executor should be enabled
#
# $jobs_service_ensure::          Whether the Dynflow executor should be running or stopped
#
# $hsts_enabled::                 Should HSTS enforcement in https requests be enabled
#
# $cors_domains::                 List of domains that show be allowed for Cross-Origin Resource Sharing. This requires Foreman 1.22+
#
class foreman (
  Stdlib::HTTPUrl $foreman_url = $::foreman::params::foreman_url,
  Boolean $unattended = $::foreman::params::unattended,
  Optional[Stdlib::HTTPUrl] $unattended_url = $::foreman::params::unattended_url,
  Boolean $apache = $::foreman::params::apache,
  Boolean $passenger = $::foreman::params::passenger,
  Optional[String] $passenger_ruby = $::foreman::params::passenger_ruby,
  Optional[String] $passenger_ruby_package = $::foreman::params::passenger_ruby_package,
  String $plugin_prefix = $::foreman::params::plugin_prefix,
  Stdlib::Fqdn $servername = $::foreman::params::servername,
  Array[Stdlib::Fqdn] $serveraliases = $::foreman::params::serveraliases,
  Boolean $ssl = $::foreman::params::ssl,
  Optional[String] $repo = $::foreman::params::repo,
  Boolean $configure_epel_repo = $::foreman::params::configure_epel_repo,
  Boolean $configure_scl_repo = $::foreman::params::configure_scl_repo,
  Optional[Boolean] $selinux = $::foreman::params::selinux,
  Boolean $gpgcheck = $::foreman::params::gpgcheck,
  String $version = $::foreman::params::version,
  Enum['installed', 'present', 'latest'] $plugin_version = $::foreman::params::plugin_version,
  Boolean $db_manage = $::foreman::params::db_manage,
  Enum['mysql', 'postgresql', 'sqlite'] $db_type = $::foreman::params::db_type,
  Optional[Enum['mysql2', 'postgresql', 'sqlite3', 'UNSET']] $db_adapter = 'UNSET',
  Optional[Stdlib::Host] $db_host = 'UNSET',
  Variant[Undef, Enum['UNSET'], Stdlib::Port] $db_port = 'UNSET',
  Optional[String] $db_database = 'UNSET',
  Optional[String] $db_username = $::foreman::params::db_username,
  Optional[String] $db_password = $::foreman::params::db_password,
  Optional[String] $db_sslmode = 'UNSET',
  Optional[String] $db_root_cert = undef,
  Integer[0] $db_pool = $::foreman::params::db_pool,
  Boolean $db_manage_rake = $::foreman::params::db_manage_rake,
  Stdlib::Absolutepath $app_root = $::foreman::params::app_root,
  Boolean $manage_user = $::foreman::params::manage_user,
  String $user = $::foreman::params::user,
  String $group = $::foreman::params::group,
  Array[String] $user_groups = $::foreman::params::user_groups,
  String $rails_env = $::foreman::params::rails_env,
  Optional[String] $passenger_interface = $::foreman::params::passenger_interface,
  String $vhost_priority = $::foreman::params::vhost_priority,
  Stdlib::Port $server_port = $::foreman::params::server_port,
  Stdlib::Port $server_ssl_port = $::foreman::params::server_ssl_port,
  Stdlib::Absolutepath $server_ssl_ca = $::foreman::params::server_ssl_ca,
  Stdlib::Absolutepath $server_ssl_chain = $::foreman::params::server_ssl_chain,
  Stdlib::Absolutepath $server_ssl_cert = $::foreman::params::server_ssl_cert,
  Variant[Enum[''], Stdlib::Absolutepath] $server_ssl_certs_dir = $::foreman::params::server_ssl_certs_dir,
  Stdlib::Absolutepath $server_ssl_key = $::foreman::params::server_ssl_key,
  Variant[Enum[''], Stdlib::Absolutepath] $server_ssl_crl = $::foreman::params::server_ssl_crl,
  Optional[String] $server_ssl_protocol = $::foreman::params::server_ssl_protocol,
  Stdlib::Absolutepath $client_ssl_ca = $::foreman::params::client_ssl_ca,
  Stdlib::Absolutepath $client_ssl_cert = $::foreman::params::client_ssl_cert,
  Stdlib::Absolutepath $client_ssl_key = $::foreman::params::client_ssl_key,
  Boolean $keepalive = $::foreman::params::keepalive,
  Integer[0] $max_keepalive_requests = $::foreman::params::max_keepalive_requests,
  Integer[0] $keepalive_timeout = $::foreman::params::keepalive_timeout,
  Boolean $oauth_active = $::foreman::params::oauth_active,
  Boolean $oauth_map_users = $::foreman::params::oauth_map_users,
  String $oauth_consumer_key = $::foreman::params::oauth_consumer_key,
  String $oauth_consumer_secret = $::foreman::params::oauth_consumer_secret,
  Boolean $passenger_prestart = $::foreman::params::passenger_prestart,
  Integer[0] $passenger_min_instances = $::foreman::params::passenger_min_instances,
  Integer[0] $passenger_start_timeout = $::foreman::params::passenger_start_timeout,
  String $initial_admin_username = $::foreman::params::initial_admin_username,
  String $initial_admin_password = $::foreman::params::initial_admin_password,
  Optional[String] $initial_admin_first_name = $::foreman::params::initial_admin_first_name,
  Optional[String] $initial_admin_last_name = $::foreman::params::initial_admin_last_name,
  Optional[String] $initial_admin_email = $::foreman::params::initial_admin_email,
  Optional[String] $initial_organization = $::foreman::params::initial_organization,
  Optional[String] $initial_location = $::foreman::params::initial_location,
  Boolean $ipa_authentication = $::foreman::params::ipa_authentication,
  Stdlib::Absolutepath $http_keytab = $::foreman::params::http_keytab,
  String $pam_service = $::foreman::params::pam_service,
  Boolean $ipa_manage_sssd = $::foreman::params::ipa_manage_sssd,
  Boolean $websockets_encrypt = $::foreman::params::websockets_encrypt,
  Stdlib::Absolutepath $websockets_ssl_key = $::foreman::params::websockets_ssl_key,
  Stdlib::Absolutepath $websockets_ssl_cert = $::foreman::params::websockets_ssl_cert,
  Enum['debug', 'info', 'warn', 'error', 'fatal'] $logging_level = $::foreman::params::logging_level,
  Enum['file', 'syslog', 'journald'] $logging_type = $::foreman::params::logging_type,
  Enum['pattern', 'multiline_pattern', 'json'] $logging_layout = $::foreman::params::logging_layout,
  Hash[String, Boolean] $loggers = $::foreman::params::loggers,
  Optional[Enum['sendmail', 'smtp']] $email_delivery_method = $::foreman::params::email_delivery_method,
  Optional[Stdlib::Host] $email_smtp_address = $::foreman::params::email_smtp_address,
  Stdlib::Port $email_smtp_port = $::foreman::params::email_smtp_port,
  Optional[Stdlib::Fqdn] $email_smtp_domain = $::foreman::params::email_smtp_domain,
  Enum['none', 'plain', 'login', 'cram-md5'] $email_smtp_authentication = $::foreman::params::email_smtp_authentication,
  Optional[String] $email_smtp_user_name = $::foreman::params::email_smtp_user_name,
  Optional[String] $email_smtp_password = $::foreman::params::email_smtp_password,
  String $telemetry_prefix = $::foreman::params::telemetry_prefix,
  Boolean $telemetry_prometheus_enabled = $::foreman::params::telemetry_prometheus_enabled,
  Boolean $telemetry_statsd_enabled = $::foreman::params::telemetry_statsd_enabled,
  String $telemetry_statsd_host = $::foreman::params::telemetry_statsd_host,
  Enum['statsd', 'statsite', 'datadog'] $telemetry_statsd_protocol = $::foreman::params::telemetry_statsd_protocol,
  Boolean $telemetry_logger_enabled = $::foreman::params::telemetry_logger_enabled,
  Enum['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'] $telemetry_logger_level = $::foreman::params::telemetry_logger_level,
  Stdlib::Port $dynflow_pool_size = $::foreman::params::dynflow_pool_size,
  String $jobs_service = $::foreman::params::jobs_service,
  Stdlib::Ensure::Service $jobs_service_ensure = $::foreman::params::jobs_service_ensure,
  Boolean $jobs_service_enable = $::foreman::params::jobs_service_enable,
  Boolean $hsts_enabled = $::foreman::params::hsts_enabled,
  Array[Stdlib::HTTPUrl] $cors_domains = $::foreman::params::cors_domains,
) inherits foreman::params {
  if $db_adapter == 'UNSET' {
    $db_adapter_real = $::foreman::db_type ? {
      'sqlite' => 'sqlite3',
      'mysql'  => 'mysql2',
      default  => $::foreman::db_type,
    }
  } else {
    $db_adapter_real = $db_adapter
  }

  if $db_sslmode == 'UNSET' and $db_root_cert and $db_type == 'postgresql' {
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
    $foreman_service_bind = undef
  }

  include ::foreman::repo
  include ::foreman::install
  include ::foreman::config
  include ::foreman::database
  contain ::foreman::service

  Class['foreman::repo'] ~> Class['foreman::install']
  Class['foreman::install'] ~> Class['foreman::config', 'foreman::service']
  Class['foreman::config'] ~> Class['foreman::database', 'foreman::service']
  Class['foreman::service'] -> Foreman_smartproxy <| base_url == $foreman_url |>

  if $apache {
    Class['foreman::database'] -> Class['apache::service']
  } elsif $ipa_authentication {
    fail("${::hostname}: External authentication via IPA can only be enabled when Apache is used.")
  }

  # Anchor these separately so as not to break
  # the notify between main classes
  Class['foreman::install']
  ~> Package <| tag == 'foreman-compute' |>
  ~> Class['foreman::service']

  Class['foreman::repo']
  ~> Package <| tag == 'foreman::cli' |>
  ~> Class['foreman']

  Class['foreman::repo']
  ~> Package <| tag == 'foreman::providers' |>
  -> Class['foreman']

  # lint:ignore:spaceship_operator_without_tag
  Class['foreman::database']
  ~> Foreman::Plugin <| |>
  ~> Class['foreman::service']
  # lint:endignore

  contain 'foreman::settings' # lint:ignore:relative_classname_inclusion (PUP-1597)
  Class['foreman::database'] -> Class['foreman::settings']
}
