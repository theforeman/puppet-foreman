# Configure the foreman service
class foreman::service {
  case $foreman::passenger {
    true: {
      exec {'restart_foreman':
        command     => "/bin/touch ${foreman::app_root}/tmp/restart.txt",
        refreshonly => true,
        cwd         => $foreman::app_root,
        path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }

      $service_ensure = 'stopped'
      $service_enabled = false
    }
    default, false: {
      $service_ensure  = 'running'
      $service_enabled = true
    }
  }

  service {'foreman':
    ensure    => $service_ensure,
    enable    => $service_enabled,
    hasstatus => true,
  }
}
