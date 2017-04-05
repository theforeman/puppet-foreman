# Manage your foreman server
#
# === Parameters:
#
# $admin_username::             Username for the initial admin user
#
# $admin_password::             Password of the initial admin user, default is randomly generated
#
# $admin_first_name::           First name of the initial admin user
#
# $admin_last_name::            Last name of the initial admin user
#
# $admin_email::                E-mail address of the initial admin user
#
# $db_manage::                  if enabled, will install and configure the database server on this host
#
# $db_type::                    Database 'production' type
#
# $email_delivery_method::      Email delivery method
#
# $email_smtp_address::         SMTP server hostname, when delivery method is SMTP
#
# $email_smtp_port::            SMTP port
#
# $email_smtp_domain::          SMTP HELO domain
#
# $email_smtp_authentication::  SMTP authentication method
#
# $email_smtp_user_name::       Username for SMTP server auth, if authentication is enabled
#
# $email_smtp_password::        Password for SMTP server auth, if authentication is enabled
#
# $locations_enabled::          Enable locations?
#
# $organizations_enabled::      Enable organizations?
#
# $initial_organization::       Name of an initial organization
#
# $initial_location::           Name of an initial location
#
# $ipa_authentication::         Enable configuration for external authentication via IPA
#
# $puppetrun::                  Should Foreman be able to start Puppet runs on nodes
#
# === Advanced parameters:
#
# $email_source::               Template to use for email configuration file
#
# $foreman_url::                URL on which foreman is going to run
#
# $unattended::                 Should Foreman manage host provisioning as well
#
# $authentication::             Enable user authentication. Initial credentials are set using admin_username
#                               and admin_password.
#
# $passenger::                  Configure foreman via apache and passenger
#
# $passenger_ruby::             Ruby interpreter used to run Foreman under Passenger
#
# $passenger_ruby_package::     Package to install to provide Passenger libraries for the active Ruby
#                               interpreter
#
# $plugin_prefix::              String which is prepended to the plugin package names
#
# $use_vhost::                  Enclose apache configuration in VirtualHost tags
#
# $servername::                 Server name of the VirtualHost in the webserver
#
# $serveraliases::              Server aliases of the VirtualHost in the webserver
#
# $ssl::                        Enable and set require_ssl in Foreman settings (note: requires passenger, SSL does not apply to kickstarts)
#
# $custom_repo::                No need to change anything here by default
#                               if set to true, no repo will be added by this module, letting you to
#                               set it to some custom location.
#
# $repo::                       This can be stable, nightly or a specific version i.e. 1.7
#
# $configure_epel_repo::        If disabled the EPEL repo will not be configured on Red Hat family systems.
#
# $configure_scl_repo::         If disabled the SCL repo will not be configured on Red Hat clone systems.
#                               (Currently only installs repos for CentOS and Scientific)
#
# $selinux::                    When undef, foreman-selinux will be installed if SELinux is enabled
#                               setting to false/true will override this check (e.g. set to false on 1.1)
#
# $gpgcheck::                   Turn on/off gpg check in repo files (effective only on RedHat family systems)
#
# $version::                    Foreman package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
# $plugin_version::             Foreman plugins package version, it's passed to ensure parameter of package resource
#                               can be set to 'installed', 'latest', 'present' only
#
# $db_adapter::                 Database 'production' adapter
#
# $db_host::                    Database 'production' host
#
# $db_port::                    Database 'production' port
#
# $db_database::                Database 'production' database (e.g. foreman)
#
# $db_username::                Database 'production' user (e.g. foreman)
#
# $db_password::                Database 'production' password, default is randomly generated
#
# $db_sslmode::                 Database 'production' ssl mode
#
# $db_pool::                    Database 'production' size of connection pool
#
# $db_manage_rake::             if enabled, will run rake jobs, which depend on the database
#
# $app_root::                   Name of foreman root directory
#
# $manage_user::                Controls whether foreman module will manage the user on the system.
#
# $user::                       User under which foreman will run
#
# $group::                      Primary group for the Foreman user
#
# $rails_env::                  Rails environment of foreman
#
# $user_groups::                Additional groups for the Foreman user
#
# $puppet_home::                Puppet home directory
#
# $puppet_ssldir::              Puppet SSL directory
#
# $passenger_interface::        Defines which network interface passenger should listen on, undef means all interfaces
#
# $passenger_prestart::         Pre-start the first passenger worker instance process during httpd start.
#
# $passenger_min_instances::    Minimum passenger worker instances to keep when application is idle.
#
# $passenger_start_timeout::    Amount of seconds to wait for Ruby application boot.
#
# $vhost_priority::             Defines Apache vhost priority for the Foreman vhost conf file.
#
# $server_port::                Defines Apache port for HTTP requests
#
# $server_ssl_port::            Defines Apache port for HTTPS reqquests
#
# $server_ssl_ca::              Defines Apache mod_ssl SSLCACertificateFile setting in Foreman vhost conf file.
#
# $server_ssl_chain::           Defines Apache mod_ssl SSLCertificateChainFile setting in Foreman vhost conf file.
#
# $server_ssl_cert::            Defines Apache mod_ssl SSLCertificateFile setting in Foreman vhost conf file.
#
# $server_ssl_certs_dir::       Defines Apache mod_ssl SSLCACertificatePath setting in Foreman vhost conf file.
#
# $server_ssl_key::             Defines Apache mod_ssl SSLCertificateKeyFile setting in Foreman vhost conf file.
#
# $server_ssl_crl::             Defines the Apache mod_ssl SSLCARevocationFile setting in Foreman vhost conf file.
#
# $client_ssl_ca::              Defines the SSL CA used to communicate with Foreman Proxies
#
# $client_ssl_cert::            Defines the SSL certificate used to communicate with Foreman Proxies
#
# $client_ssl_key::             Defines the SSL private key used to communicate with Foreman Proxies
#
# $keepalive::                  Enable KeepAlive setting of Apache?
#
# $max_keepalive_requests::     MaxKeepAliveRequests setting of Apache
#                               (Number of requests allowed on a persistent connection)
#
# $keepalive_timeout::          KeepAliveTimeout setting of Apache
#                               (Seconds the server will wait for subsequent requests on a persistent connection)
#
# $oauth_active::               Enable OAuth authentication for REST API
#
# $oauth_map_users::            Should Foreman use the foreman_user header to identify API user?
#
# $oauth_consumer_key::         OAuth consumer key
#
# $oauth_consumer_secret::      OAuth consumer secret
#
# $http_keytab::                Path to keytab to be used for Kerberos authentication on the WebUI
#
# $pam_service::                PAM service used for host-based access control in IPA
#
# $ipa_manage_sssd::            If ipa_authentication is true, should the installer manage SSSD? You can disable it
#                               if you use another module for SSSD configuration
#
# $websockets_encrypt::         Whether to encrypt websocket connections
#
# $websockets_ssl_key::         SSL key file to use when encrypting websocket connections
#
# $websockets_ssl_cert::        SSL certificate file to use when encrypting websocket connections
#
# $logging_level::              Logging level of the Foreman application
#
# $loggers::                    Enable or disable specific loggers, e.g. {"sql" => true}
#
# $email_config_method::        Configure email settings in database (1.14+) or configuration file (deprecated)
#
# $email_conf::                 Email configuration file under /etc/foreman
#
class foreman (
  Stdlib::HTTPUrl $foreman_url = $::foreman::params::foreman_url,
  Boolean $puppetrun = $::foreman::params::puppetrun,
  Boolean $unattended = $::foreman::params::unattended,
  Boolean $authentication = $::foreman::params::authentication,
  Boolean $passenger = $::foreman::params::passenger,
  Optional[String] $passenger_ruby = $::foreman::params::passenger_ruby,
  Optional[String] $passenger_ruby_package = $::foreman::params::passenger_ruby_package,
  String $plugin_prefix = $::foreman::params::plugin_prefix,
  Boolean $use_vhost = $::foreman::params::use_vhost,
  String $servername = $::foreman::params::servername,
  Array[String] $serveraliases = $::foreman::params::serveraliases,
  Boolean $ssl = $::foreman::params::ssl,
  Boolean $custom_repo = $::foreman::params::custom_repo,
  String $repo = $::foreman::params::repo,
  Boolean $configure_epel_repo = $::foreman::params::configure_epel_repo,
  Boolean $configure_scl_repo = $::foreman::params::configure_scl_repo,
  Optional[Boolean] $selinux = $::foreman::params::selinux,
  Boolean $gpgcheck = $::foreman::params::gpgcheck,
  String $version = $::foreman::params::version,
  Enum['installed', 'present', 'latest'] $plugin_version = $::foreman::params::plugin_version,
  Boolean $db_manage = $::foreman::params::db_manage,
  Enum['mysql', 'postgresql', 'sqlite'] $db_type = $::foreman::params::db_type,
  Optional[Enum['mysql2', 'postgresql', 'sqlite3', 'UNSET']] $db_adapter = 'UNSET',
  Optional[String] $db_host = 'UNSET',
  Variant[Undef, Enum['UNSET'], Integer[0, 65535]] $db_port = 'UNSET',
  Optional[String] $db_database = 'UNSET',
  Optional[String] $db_username = $::foreman::params::db_username,
  Optional[String] $db_password = $::foreman::params::db_password,
  Optional[String] $db_sslmode = 'UNSET',
  Integer[0] $db_pool = $::foreman::params::db_pool,
  Boolean $db_manage_rake = $::foreman::params::db_manage_rake,
  Stdlib::Absolutepath $app_root = $::foreman::params::app_root,
  Boolean $manage_user = $::foreman::params::manage_user,
  String $user = $::foreman::params::user,
  String $group = $::foreman::params::group,
  Array[String] $user_groups = $::foreman::params::user_groups,
  String $rails_env = $::foreman::params::rails_env,
  Stdlib::Absolutepath $puppet_home = $::foreman::params::puppet_home,
  Stdlib::Absolutepath $puppet_ssldir = $::foreman::params::puppet_ssldir,
  Boolean $locations_enabled = $::foreman::params::locations_enabled,
  Boolean $organizations_enabled = $::foreman::params::organizations_enabled,
  Optional[String] $passenger_interface = $::foreman::params::passenger_interface,
  String $vhost_priority = $::foreman::params::vhost_priority,
  Integer[0, 65535] $server_port = $::foreman::params::server_port,
  Integer[0, 65535] $server_ssl_port = $::foreman::params::server_ssl_port,
  Stdlib::Absolutepath $server_ssl_ca = $::foreman::params::server_ssl_ca,
  Stdlib::Absolutepath $server_ssl_chain = $::foreman::params::server_ssl_chain,
  Stdlib::Absolutepath $server_ssl_cert = $::foreman::params::server_ssl_cert,
  Variant[String[0], Stdlib::Absolutepath] $server_ssl_certs_dir = $::foreman::params::server_ssl_certs_dir,
  Stdlib::Absolutepath $server_ssl_key = $::foreman::params::server_ssl_key,
  Optional[Variant[String[0], Stdlib::Absolutepath]] $server_ssl_crl = $::foreman::params::server_ssl_crl,
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
  String $admin_username = $::foreman::params::admin_username,
  String $admin_password = $::foreman::params::admin_password,
  Optional[String] $admin_first_name = $::foreman::params::admin_first_name,
  Optional[String] $admin_last_name = $::foreman::params::admin_last_name,
  Optional[String] $admin_email = $::foreman::params::admin_email,
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
  Hash[String, Boolean] $loggers = $::foreman::params::loggers,
  Enum['database', 'file'] $email_config_method = $::foreman::params::email_config_method,
  String $email_conf = $::foreman::params::email_conf,
  String $email_source = $::foreman::params::email_source,
  Optional[Enum['sendmail', 'smtp']] $email_delivery_method = $::foreman::params::email_delivery_method,
  Optional[String] $email_smtp_address = $::foreman::params::email_smtp_address,
  Integer[0, 65535] $email_smtp_port = $::foreman::params::email_smtp_port,
  Optional[String] $email_smtp_domain = $::foreman::params::email_smtp_domain,
  Enum['none', 'plain', 'login', 'cram-md5'] $email_smtp_authentication = $::foreman::params::email_smtp_authentication,
  Optional[String] $email_smtp_user_name = $::foreman::params::email_smtp_user_name,
  Optional[String] $email_smtp_password = $::foreman::params::email_smtp_password,
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
  if $passenger == false and $ipa_authentication {
    fail("${::hostname}: External authentication via IPA can only be enabled when passenger is used.")
  }

  include ::foreman::repo

  Class['foreman::repo']
  ~> class { '::foreman::install': }
  ~> class { '::foreman::config': }
  ~> class { '::foreman::database': }
  ~> class { '::foreman::service': }
  -> Class['foreman']
  -> Foreman_smartproxy <| base_url == $foreman_url |>

  # When db_manage and db_manage_rake are false, this extra relationship is required.
  Class['foreman::config'] ~> Class['foreman::service']

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
