# Manage your foreman server
class foreman (
  $foreman_url            = $foreman::params::foreman_url,
  $enc                    = $foreman::params::enc,
  $reports                = $foreman::params::reports,
  $facts                  = $foreman::params::facts,
  $unattended             = $foreman::params::unattended,
  $authentication         = $foreman::params::authentication,
  $passenger              = $foreman::params::passenger,
  $passenger_scl          = $foreman::params::passenger_scl,
  $use_vhost              = $foreman::params::use_vhost,
  $ssl                    = $foreman::params::ssl,
  $custom_repo            = $foreman::params::custom_repo,
  $repo                   = $foreman::params::repo,
  $selinux                = $foreman::params::selinux,
  $gpgcheck               = $foreman::params::gpgcheck,
  $version                = $foreman::params::version,
  $db_manage              = $foreman::params::db_manage,
  $db_type                = $foreman::params::db_type,
  $db_adapter             = 'UNSET',
  $db_host                = 'UNSET',
  $db_port                = 'UNSET',
  $db_database            = 'UNSET',
  $db_username            = $foreman::params::db_username,
  $db_password            = $foreman::params::db_password,
  $db_sslmode             = 'UNSET',
  $railspath              = $foreman::params::railspath,
  $app_root               = $foreman::params::app_root,
  $user                   = $foreman::params::user,
  $environment            = $foreman::params::environment,
  $puppet_basedir         = $foreman::params::puppet_basedir,
  $apache_conf_dir        = $foreman::params::apache_conf_dir,
  $puppet_home            = $foreman::params::puppet_home,
  $locations_enabled      = $foreman::params::locations_enabled,
  $organizations_enabled  = $foreman::params::organizations_enabled,
  $passenger_interface    = $foreman::params::passenger_interface,
  $oauth_active           = $foreman::params::oauth_active,
  $oauth_map_users        = $foreman::params::oauth_map_users,
  $oauth_consumer_key     = $foreman::params::oauth_consumer_key,
  $oauth_consumer_secret  = $foreman::params::oauth_consumer_secret
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
  class { 'foreman::install': } ~>
  class { 'foreman::config': } ~>
  class { 'foreman::database': } ~>
  class { 'foreman::service': }
}
