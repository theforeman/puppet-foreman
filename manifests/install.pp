# Install the needed packages for foreman
class foreman::install {

  package { 'foreman-postgresql':
    ensure => $::foreman::version,
  }

  if $facts['selinux'] {
    package { 'foreman-selinux':
      ensure => $::foreman::version,
    }
  }

  if $::foreman::apache and $::foreman::passenger and $::foreman::passenger_ruby_package {
    package { $::foreman::passenger_ruby_package:
      ensure => installed,
      before => Class['apache::service'],
    }
  }

  if $::foreman::use_foreman_service {
    package { 'foreman-service':
      ensure => installed,
    }
  }

  if $::foreman::jobs_manage_service {
    package { 'foreman-dynflow-sidekiq':
      ensure => installed,
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

  if $::foreman::logging_type == 'journald' {
    package { 'foreman-journald':
      ensure => installed,
    }
  }
}
