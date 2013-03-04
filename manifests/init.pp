class foreman (
  $foreman_url            = $foreman::params::foreman_url,
  $enc                    = $foreman::params::enc,
  $reports                = $foreman::params::reports,
  $facts                  = $foreman::params::facts,
  $storeconfigs           = $foreman::params::storeconfigs,
  $unattended             = $foreman::params::unattended,
  $authentication         = $foreman::params::authentication,
  $passenger              = $foreman::params::passenger,
  $use_vhost              = $foreman::params::use_vhost,
  $ssl                    = $foreman::params::ssl,
  $custom_repo            = $foreman::params::custom_repo,
  $repo                   = $foreman::params::repo,
  $use_sqlite             = $foreman::params::use_sqlite,
  $railspath              = $foreman::params::railspath,
  $app_root               = $foreman::params::app_root,
  $user                   = $foreman::params::user,
  $environment            = $foreman::params::environment,
  $puppet_basedir         = $foreman::params::puppet_basedir,
  $apache_conf_dir        = $foreman::params::apache_conf_dir,
  $puppet_home            = $foreman::params::puppet_home,
  $locations_enabled      = $foreman::params::locations_enabled,
  $organizations_enabled  = $foreman::params::organizations_enabled
) inherits foreman::params {
  class { 'foreman::install': } ~>
  class { 'foreman::config': } ~>
  class { 'foreman::service': }
}
