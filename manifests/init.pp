class foreman (
  $foreman_url     = $foreman::params::foreman_url,
  $enc             = $foreman::params::enc,
  $reports         = $foreman::params::reports,
  $facts           = $foreman::params::facts,
  $storeconfigs    = $foreman::params::storeconfigs,
  $unattended      = $foreman::params::unattended,
  $authentication  = $foreman::params::authentication,
  $passenger       = $foreman::params::passenger,
  $ssl             = $foreman::params::ssl,
  $custom_repo     = $foreman::params::custom_repo,
  $use_testing     = $foreman::params::use_testing,
  $railspath       = $foreman::params::railspath,
  $app_root        = $foreman::params::app_root,
  $user            = $foreman::params::user,
  $environment     = $foreman::params::environment,
  $package_source  = $foreman::params::package_source,
  $puppet_basedir  = $foreman::params::puppet_basedir,
  $apache_conf_dir = $foreman::params::apache_conf_dir,
  $puppet_home     = $foreman::params::puppet_home
) inherits foreman::params {
  class { 'foreman::install': } ~>
  class { 'foreman::config': } ~>
  class { 'foreman::service': }
}
