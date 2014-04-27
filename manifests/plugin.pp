define foreman::plugin(
  $package = "${foreman::plugin_prefix}${title}"
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
}
