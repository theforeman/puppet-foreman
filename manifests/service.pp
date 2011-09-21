class foreman::service {
  service {"foreman":
    ensure => $foreman::params::passenger ? {
      true => "stopped",
      false => "running"
    },
    enable => $foreman::params::passenger ? {
      true => "false",
      false => "true",
    },
    hasstatus => true,
  }
}
