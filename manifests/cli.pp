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
# $manage_root_config::   Whether to manage /root/.hammer configuration.
#
# $refresh_cache::        Check API documentation cache status on each request
#
# $request_timeout::      API request timeout, set -1 for infinity
#
# $ssl_ca_file::          Path to SSL certificate authority
#
# $hammer_plugin_prefix:: Hammer plugin package prefix based normally on platform
#
# $version::              foreman-cli package version, it's passed to ensure parameter of package resource
#                         can be set to specific version number, 'latest', 'present' etc.
#
class foreman::cli (
  Optional[Stdlib::HTTPUrl] $foreman_url = $::foreman::cli::params::foreman_url,
  String $version = $::foreman::cli::params::version,
  Boolean $manage_root_config = $::foreman::cli::params::manage_root_config,
  Optional[String] $username = $::foreman::cli::params::username,
  Optional[String] $password = $::foreman::cli::params::password,
  Boolean $refresh_cache = $::foreman::cli::params::refresh_cache,
  Integer[-1] $request_timeout = $::foreman::cli::params::request_timeout,
  Optional[Stdlib::Absolutepath] $ssl_ca_file = $::foreman::cli::params::ssl_ca_file,
  String $hammer_plugin_prefix = $::foreman::cli::params::hammer_plugin_prefix,
) inherits foreman::cli::params {
  # Inherit URL & auth parameters from foreman class if possible
  #
  # The parameter existence must be checked in case strict variables is enabled, but this will only
  # work since PUP-4072 (3.7.5+) due to a bug resolving variables outside of this class.
  if versioncmp($::puppetversion, '3.7.5') < 0 or defined('$foreman::foreman_url') {
    $foreman_url_real = pick($foreman_url, $::foreman::foreman_url)
    $username_real    = pick($username, $::foreman::initial_admin_username)
    $password_real    = pick($password, $::foreman::initial_admin_password)
    $ssl_ca_file_real = pick($ssl_ca_file, $::foreman::server_ssl_chain)
  } else {
    $foreman_url_real = $foreman_url
    $username_real    = $username
    $password_real    = $password
    $ssl_ca_file_real = $ssl_ca_file
  }

  package { 'foreman-cli':
    ensure => $version,
  }
  -> file { '/etc/hammer/cli.modules.d/foreman.yml':
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
