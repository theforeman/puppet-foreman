define foreman::plugin(
  $package = "${foreman::plugin_prefix}${title}",
  $config  = '',
) {
  # Debian gem2deb converts underscores to hyphens
  case $::osfamily {
    'Debian': {
      $real_package = regsubst($package,'_','-','G')
    }
    default: {
      $real_package = $package
    }
  }
  package { $real_package:
    ensure => installed,
    notify => Class['foreman::service'],
  }

  if $config {
    file { "/etc/foreman/plugins/${name}.yaml":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $config,
      require => Package[$real_package],
      notify  => Class['foreman::service'],
    }
  }
}
