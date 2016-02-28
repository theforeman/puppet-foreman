# Configure the foreman service
class foreman::service(
  $passenger = $::foreman::passenger,
  $app_root  = $::foreman::app_root,
) {
  if $passenger {
    exec {'restart_foreman':
      command     => "/bin/touch ${app_root}/tmp/restart.txt",
      refreshonly => true,
      cwd         => $app_root,
      path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
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
