# = Foreman command line interface
#
# This class installs the Hammer command line interface (CLI).
#
# === Parameters:
#
# $foreman_url::        URL on which Foreman runs
#
# $username::           Username for authentication
#
# $password::           Password for authentication
#
# === Advanced parameters:
#
# $manage_root_config:: Whether to manage /root/.hammer configuration.
#                       type:boolean
#
# $refresh_cache::      Check API documentation cache status on each request
#                       type:boolean
#
# $request_timeout::    API request timeout, set -1 for infinity
#                       type:integer
#
# $version::            foreman-cli package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#
class foreman::cli (
  $foreman_url        = $::foreman::cli::params::foreman_url,
  $version            = $::foreman::cli::params::version,
  $manage_root_config = $::foreman::cli::params::manage_root_config,
  $username           = $::foreman::cli::params::username,
  $password           = $::foreman::cli::params::password,
  $refresh_cache      = $::foreman::cli::params::refresh_cache,
  $request_timeout    = $::foreman::cli::params::request_timeout,
) inherits foreman::cli::params {
  # Inherit URL & auth parameters from foreman class if possible
  #
  # The parameter existence must be checked in case strict variables is enabled, but this will only
  # work since PUP-4072 (3.7.5+) due to a bug resolving variables outside of this class.
  if versioncmp($::puppetversion, '3.7.5') < 0 or defined('$foreman::foreman_url') {
    $foreman_url_real = pick($foreman_url, $::foreman::foreman_url)
    $username_real    = pick($username, $::foreman::admin_username)
    $password_real    = pick($password, $::foreman::admin_password)
  } else {
    $foreman_url_real = $foreman_url
    $username_real    = $username
    $password_real    = $password
  }
  validate_string($foreman_url_real, $username_real, $password_real)
  validate_bool($manage_root_config, $refresh_cache)

  package { 'foreman-cli':
    ensure => $version,
  } ->
  file { '/etc/hammer/cli.modules.d/foreman.yml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('foreman/hammer_etc.yml.erb'),
  }

  # Separate configuration for admin username/password
  if $manage_root_config {
    file { '/root/.hammer':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
    file { '/root/.hammer/cli.modules.d':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
    file { '/root/.hammer/cli.modules.d/foreman.yml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      replace => false,
      content => template('foreman/hammer_root.yml.erb'),
    }
  }
}
