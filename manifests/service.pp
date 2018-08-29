# Configure the foreman service
class foreman::service(
  Boolean $passenger = $::foreman::passenger,
  Stdlib::Absolutepath $app_root = $::foreman::app_root,
  Boolean $ssl = $::foreman::ssl,
  String $jobs_service = $::foreman::jobs_service,
  Stdlib::Ensure::Service $jobs_service_ensure = $::foreman::jobs_service_ensure,
  Boolean $jobs_service_enable = $::foreman::jobs_service_enable,
) {
  anchor { ['foreman::service_begin', 'foreman::service_end']: }

  service { $jobs_service:
    ensure => $jobs_service_ensure,
    enable => $jobs_service_enable,
  }

  if $passenger {
    exec {'restart_foreman':
      command     => "/bin/touch ${app_root}/tmp/restart.txt",
      refreshonly => true,
      cwd         => $app_root,
      path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }

    # Anchor httpd service within this service class, but allow other
    # configuration within the apache module to occur before
    Anchor['foreman::service_begin'] -> Service['httpd']
    Class['::apache'] -> Anchor['foreman::service_end']

    # Ensure SSL certs from the puppetmaster are available
    # Relationship is duplicated there as defined() is parse-order dependent
    if $ssl and defined(Class['puppet::server::config']) {
      Class['puppet::server::config'] -> Class['foreman::service']
    }

    $service_ensure = 'stopped'
    $service_enabled = false
  } else {
    $service_ensure  = 'running'
    $service_enabled = true
  }

  service {'foreman':
    ensure    => $service_ensure,
    enable    => $service_enabled,
    hasstatus => true,
  }
}
