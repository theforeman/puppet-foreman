# Configure the foreman service
class foreman::service {
  case $foreman::passenger {
    true: {
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
