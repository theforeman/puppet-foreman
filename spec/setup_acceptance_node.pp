$configure_scl_repo = $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '7'

class { 'foreman::repo':
  repo                => '2.0',
  gpgcheck            => false,
  configure_epel_repo => false,
  configure_scl_repo  => $configure_scl_repo,
}

# Needed for idempotency when SELinux is enabled
if $configure_scl_repo {
  package { 'rh-redis5-redis':
    ensure  => installed,
    require => Class['foreman::repo'],
  }
}
