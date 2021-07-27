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
# $use_sessions::         Enable using sessions
#
# $refresh_cache::        Check API documentation cache status on each request
#
# $request_timeout::      API request timeout, set -1 for infinity
#
# $ssl_ca_file::          Path to SSL certificate authority
#
# $version::              foreman-cli package version, it's passed to ensure parameter of package resource
#                         can be set to specific version number, 'latest', 'present' etc.
#
class foreman::cli (
  Optional[Stdlib::HTTPUrl] $foreman_url = undef,
  String $version = 'installed',
  Boolean $manage_root_config = true,
  Optional[String] $username = undef,
  Optional[String] $password = undef,
  Boolean $use_sessions = false,
  Boolean $refresh_cache = false,
  Integer[-1] $request_timeout = 120,
  Optional[Stdlib::Absolutepath] $ssl_ca_file = undef,
) inherits foreman::cli::params {
  # Inherit URL & auth parameters from foreman class if possible
  if defined('$foreman::foreman_url') {
    $foreman_url_real = pick($foreman_url, $foreman::foreman_url)
    $username_real    = pick($username, $foreman::initial_admin_username)
    $password_real    = pick($password, $foreman::initial_admin_password)
    $ssl_ca_file_real = pick($ssl_ca_file, $foreman::server_ssl_chain)
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
    content => epp(
      'foreman/hammer_etc.yml.epp',
      {
        host            => $foreman_url_real,
        use_sessions    => $use_sessions,
        refresh_cache   => $refresh_cache,
        request_timeout => $request_timeout,
        ssl_ca_file     => $ssl_ca_file_real,
      }
    ),
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
      content => epp(
        'foreman/hammer_root.yml.epp',
        {
          username => $username_real,
          password => $password_real,
        }
      ),
    }
  }

  Anchor <| title == 'foreman::repo' |> ~> Package <| tag == 'foreman::cli' |>
}
