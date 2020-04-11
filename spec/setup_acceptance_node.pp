$configure_scl_repo = $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '7'

# Needed for idempotency when SELinux is enabled
if $configure_scl_repo {
  package { 'centos-release-scl-rh':
    ensure  => installed,
  }

  package { 'rh-redis5-redis':
    ensure  => installed,
    require => Package['centos-release-scl-rh'],
  }
}
