# == Hammer plugin
#
# A generic way to install plugins
#
# === Parameters:
#
# $package:: The package name
#
# $version:: The package version to ensure
#
define foreman::cli::plugin (
  String $package = "${::foreman::cli::hammer_plugin_prefix}${title}",
  String $version = 'installed',
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
    ensure  => $version,
    # Ensures we are installing after the repositories are set up
    require => Package['foreman-cli'],
  }
}
