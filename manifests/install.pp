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

  package { 'foreman-service':
    ensure => $foreman::version,
  }

  if $foreman::dynflow_manage_services {
    package { 'foreman-dynflow-sidekiq':
      ensure => $foreman::version,
    }
  }

  if $foreman::external_authentication =~ /ipa/ and $foreman::ipa_manage_sssd {
    package { 'sssd-dbus':
      ensure => installed,
    }
  }

  if $foreman::telemetry_statsd_enabled or $foreman::telemetry_prometheus_enabled {
    package { 'foreman-telemetry':
      ensure => $foreman::version,
    }
  }

  if $foreman::logging_type == 'journald' {
    package { 'foreman-journald':
      ensure => $foreman::version,
    }
  }

  if $foreman::rails_cache_store['type'] == 'redis' {
    package { 'foreman-redis':
      ensure => $foreman::version,
    }
  }

  if $foreman::register_in_foreman {
    contain foreman::providers
  }
}
