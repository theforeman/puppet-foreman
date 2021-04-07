# Install the needed packages for foreman
class foreman::install {

  package { 'foreman-postgresql':
    ensure => $foreman::version,
  }

  if $facts['os']['selinux']['enabled'] {
    package { 'foreman-selinux':
      ensure => $foreman::version,
    }
  }

  # Foreman 2.5 dropped support for Passenger. On EL7 there was a native package built for SCL that should be absent.
  if $foreman::passenger_ruby_package {
    package { $foreman::passenger_ruby_package:
      ensure => absent,
    }
  }

  package { 'foreman-service':
    ensure => installed,
  }

  if $foreman::dynflow_manage_services {
    package { 'foreman-dynflow-sidekiq':
      ensure => installed,
    }
  }

  if $foreman::ipa_authentication and $foreman::ipa_manage_sssd {
    package { 'sssd-dbus':
      ensure => installed,
    }
  }

  if $foreman::telemetry_statsd_enabled or $foreman::telemetry_prometheus_enabled {
    package { 'foreman-telemetry':
      ensure => installed,
    }
  }

  if $foreman::logging_type == 'journald' {
    package { 'foreman-journald':
      ensure => installed,
    }
  }

  if $foreman::rails_cache_store['type'] == 'redis' {
    package { 'foreman-redis':
      ensure => installed,
    }
  }
}
