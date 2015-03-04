# Manage your foreman server
#
# === Parameters:
#
# $foreman_url::              URL on which foreman is going to run
#
# $unattended::               Should foreman manage host provisioning as well
#                             type:boolean
#
# $authentication::           Enable user authentication. Initial credentials are set using admin_username
#                             and admin_password.
#                             type:boolean
#
# $passenger::                Configure foreman via apache and passenger
#                             type:boolean
#
# $passenger_ruby::           Ruby interpreter used to run Foreman under Passenger
#
# $passenger_ruby_package::   Package to install to provide Passenger libraries for the active Ruby
#                             interpreter
#
# $use_vhost::                Enclose apache configuration in <VirtualHost>...</VirtualHost>
#                             type:boolean
#
# $servername::               Server name of the VirtualHost in the webserver
#
# $ssl::                      Enable and set require_ssl in Foreman settings (note: requires passenger, SSL does not apply to kickstarts)
#                             type:boolean
#
# $custom_repo::              No need to change anything here by default
#                             if set to true, no repo will be added by this module, letting you to
#                             set it to some custom location.
#                             type:boolean
#
# $repo::                     This can be stable, nightly or a specific version i.e. 1.7
#
# $configure_epel_repo::      If disabled the EPEL repo will not be configured on RedHat family systems.
#                             type:boolean
#
# $configure_scl_repo::       If disabled the SCL repo will not be configured on Red Hat clone systems.
#                             (Currently only installs repos for CentOS and Scientific)
#                             type:boolean
#
# $configure_brightbox_repo:: Configure the Brightbox PPA for Ubuntu, providing updated Ruby and
#                             Passenger packages
#                             type:boolean
#
# $selinux::                  when undef, foreman-selinux will be installed if SELinux is enabled
#                             setting to false/true will override this check (e.g. set to false on 1.1)
#                             type:boolean
#
# $gpgcheck::                 turn on/off gpg check in repo files (effective only on RedHat family systems)
#                             type:boolean
#
# $version::                  foreman package version, it's passed to ensure parameter of package resource
#                             can be set to specific version number, 'latest', 'present' etc.
#
# $db_manage::                if enabled, will install and configure the database server on this host
#                             type:boolean
#
# $db_type::                  Database 'production' type (valid types: mysql/postgresql/sqlite)
#
# $db_adapter::               Database 'production' adapter
#
# $db_host::                  Database 'production' host
#
# $db_port::                  Database 'production' port
#                             type:integer
#
# $db_database::              Database 'production' database (e.g. foreman)
#
# $db_username::              Database 'production' user (e.g. foreman)
#
# $db_password::              Database 'production' password (default is random)
#
# $db_sslmode::               Database 'production' ssl mode
#
# $db_pool::                  Database 'production' size of connection pool
#                             type:integer
#
# $apipie_task::              Rake task to generate API documentation.
#                             Use 'apipie:cache' on 1.7 or older, 'apipie:cache:index' on 1.8 or newer.
#
# $app_root::                 Name of foreman root directory
#
# $manage_user::              Controls whether foreman module will manage the user on the system. (default true)
#                             type:boolean
#
# $user::                     User under which foreman will run
#
# $group::                    Primary group for the Foreman user
#
# $user_groups::              Additional groups for the Foreman user
#                             type:array
#
# $environment::              Rails environment of foreman
#
# $puppet_home::              Puppet home directory
#
# $locations_enabled::        Enable locations?
#                             type:boolean
#
# $organizations_enabled::    Enable organizations?
#                             type:boolean
#
# $passenger_interface::      Defines which network interface passenger should listen on, undef means all interfaces
#
# $passenger_prestart::       Pre-start the first passenger worker instance process during httpd start.
#                             type:boolean
#
# $passenger_min_instances::  Minimum passenger worker instances to keep when application is idle.
#
# $passenger_start_timeout::  Amount of seconds to wait for Ruby application boot.
#
# $server_ssl_ca::            Defines Apache mod_ssl SSLCACertificateFile setting in Foreman vhost conf file.
#
# $server_ssl_chain::         Defines Apache mod_ssl SSLCertificateChainFile setting in Foreman vhost conf file.
#
# $server_ssl_cert::          Defines Apache mod_ssl SSLCertificateFile setting in Foreman vhost conf file.
#
# $server_ssl_key::           Defines Apache mod_ssl SSLCertificateKeyFile setting in Foreman vhost conf file.
#
# $server_ssl_crl::           Defines the Apache mod_ssl SSLCARevocationFile setting in Foreman vhost conf file.
#
# $oauth_active::             Enable OAuth authentication for REST API
#                             type:boolean
#
# $oauth_map_users::          Should foreman use the foreman_user header to identify API user?
#                             type:boolean
#
# $oauth_consumer_key::       OAuth consumer key
#
# $oauth_consumer_secret::    OAuth consumer secret
#
# $admin_username::           Username for the initial admin user
#
# $admin_password::           Password of the initial admin user, default is randomly generated
#
# $admin_first_name::         First name of the initial admin user
#
# $admin_last_name::          Last name of the initial admin user
#
# $admin_email::              E-mail address of the initial admin user
#
# $initial_organization::     Name of an initial organization
#
# $initial_location::         Name of an initial location
#
# $ipa_authentication::       Enable configuration for external authentication via IPA
#                             type:boolean
#
# $http_keytab::              Path to keytab to be used for Kerberos authentication on the WebUI
#
# $pam_service::              PAM service used for host-based access control in IPA
#
# $configure_ipa_repo::       Enable custom yum repo with packages needed for external authentication via IPA,
#                             this may be needed on RHEL 6.5 and older.
#                             type:boolean
#
# $ipa_manage_sssd::          If ipa_authentication is true, should the installer manage SSSD? You can disable it
#                             if you use another module for SSSD configuration
#                             type:boolean
#
# $websockets_encrypt::       Whether to encrypt websocket connections
#                             type:boolean
#
#
# $websockets_ssl_key::       SSL key file to use when encrypting websocket connections
# $websockets_ssl_cert::      SSL certificate file to use when encrypting websocket connections
#
class foreman (
  $foreman_url              = $foreman::params::foreman_url,
  $unattended               = $foreman::params::unattended,
  $authentication           = $foreman::params::authentication,
  $passenger                = $foreman::params::passenger,
  $passenger_ruby           = $foreman::params::passenger_ruby,
  $passenger_ruby_package   = $foreman::params::passenger_ruby_package,
  $use_vhost                = $foreman::params::use_vhost,
  $servername               = $foreman::params::servername,
  $ssl                      = $foreman::params::ssl,
  $custom_repo              = $foreman::params::custom_repo,
  $repo                     = $foreman::params::repo,
  $configure_epel_repo      = $foreman::params::configure_epel_repo,
  $configure_scl_repo       = $foreman::params::configure_scl_repo,
  $configure_brightbox_repo = $foreman::params::configure_brightbox_repo,
  $selinux                  = $foreman::params::selinux,
  $gpgcheck                 = $foreman::params::gpgcheck,
  $version                  = $foreman::params::version,
  $db_manage                = $foreman::params::db_manage,
  $db_type                  = $foreman::params::db_type,
  $db_adapter               = 'UNSET',
  $db_host                  = 'UNSET',
  $db_port                  = 'UNSET',
  $db_database              = 'UNSET',
  $db_username              = $foreman::params::db_username,
  $db_password              = $foreman::params::db_password,
  $db_sslmode               = 'UNSET',
  $db_pool                  = $foreman::params::db_pool,
  $apipie_task              = $foreman::params::apipie_task,
  $app_root                 = $foreman::params::app_root,
  $manage_user              = $foreman::params::manage_user,
  $user                     = $foreman::params::user,
  $group                    = $foreman::params::group,
  $user_groups              = $foreman::params::user_groups,
  $environment              = $foreman::params::environment,
  $puppet_home              = $foreman::params::puppet_home,
  $locations_enabled        = $foreman::params::locations_enabled,
  $organizations_enabled    = $foreman::params::organizations_enabled,
  $passenger_interface      = $foreman::params::passenger_interface,
  $server_ssl_ca            = $foreman::params::server_ssl_ca,
  $server_ssl_chain         = $foreman::params::server_ssl_chain,
  $server_ssl_cert          = $foreman::params::server_ssl_cert,
  $server_ssl_key           = $foreman::params::server_ssl_key,
  $server_ssl_crl           = $foreman::params::server_ssl_crl,
  $oauth_active             = $foreman::params::oauth_active,
  $oauth_map_users          = $foreman::params::oauth_map_users,
  $oauth_consumer_key       = $foreman::params::oauth_consumer_key,
  $oauth_consumer_secret    = $foreman::params::oauth_consumer_secret,
  $passenger_prestart       = $foreman::params::passenger_prestart,
  $passenger_min_instances  = $foreman::params::passenger_min_instances,
  $passenger_start_timeout  = $foreman::params::passenger_start_timeout,
  $admin_username           = $foreman::params::admin_username,
  $admin_password           = $foreman::params::admin_password,
  $admin_first_name         = $foreman::params::admin_first_name,
  $admin_last_name          = $foreman::params::admin_last_name,
  $admin_email              = $foreman::params::admin_email,
  $initial_organization     = $foreman::params::initial_organization,
  $initial_location         = $foreman::params::initial_location,
  $ipa_authentication       = $foreman::params::ipa_authentication,
  $http_keytab              = $foreman::params::http_keytab,
  $pam_service              = $foreman::params::pam_service,
  $configure_ipa_repo       = $foreman::params::configure_ipa_repo,
  $ipa_manage_sssd          = $foreman::params::ipa_manage_sssd,
  $websockets_encrypt       = $foreman::params::websockets_encrypt,
  $websockets_ssl_key       = $foreman::params::websockets_ssl_key,
  $websockets_ssl_cert      = $foreman::params::websockets_ssl_cert,
) inherits foreman::params {
  if $db_adapter == 'UNSET' {
    $db_adapter_real = $foreman::db_type ? {
      'sqlite' => 'sqlite3',
      'mysql'  => 'mysql2',
      default  => $foreman::db_type,
    }
  } else {
    $db_adapter_real = $db_adapter
  }
  if $passenger == false and $ipa_authentication {
    fail("${::hostname}: External authentication via IPA can only be enabled when passenger is used.")
  }

  class { '::foreman::install': } ~>
  class { '::foreman::config': } ~>
  class { '::foreman::database': } ~>
  class { '::foreman::service': } ->
  Class['foreman'] ->
  Foreman_smartproxy <| base_url == $foreman_url |>

  # Anchor these separately so as not to break
  # the notify between main classes
  Class['foreman::install'] ~>
  class { '::foreman::compute': } ~>
  Class['foreman::service']

  # lint:ignore:spaceship_operator_without_tag
  Class['foreman::database']~>
  Foreman::Plugin <| |> ~>
  Class['foreman::service']
  # lint:endignore

}
