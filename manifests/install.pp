# Install the needed packages for foreman
class foreman::install {

  case $::foreman::db_type {
    'sqlite': {
      case $::osfamily {
        'Debian': { $package = 'foreman-sqlite3' }
        default:  { $package = 'foreman-sqlite' }
      }
    }
    'postgresql': {
      $package = 'foreman-postgresql'
    }
    'mysql': {
      $package = 'foreman-mysql2'
    }
    default: {
      fail("${::hostname}: unknown database type ${::foreman::db_type}")
    }
  }

  package { $package:
    ensure  => $::foreman::version,
  }

  if $::foreman::selinux or (str2bool($::selinux) and $::foreman::selinux != false) {
    package { 'foreman-selinux':
      ensure => $::foreman::version,
    }
  }

  if $::foreman::passenger and $::foreman::passenger_ruby_package {
    package { $::foreman::passenger_ruby_package:
      ensure  => installed,
      require => Class['apache'],
      before  => Class['apache::service'],
    }
  }

  if $::foreman::ipa_authentication and $::foreman::ipa_manage_sssd {
    package { 'sssd-dbus':
      ensure => installed,
    }
  }

  if $::foreman::telemetry_statsd_enabled or $::foreman::telemetry_prometheus_enabled {
    package { 'foreman-telemetry':
      ensure => installed,
    }
  }
}
