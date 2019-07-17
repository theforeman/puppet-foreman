# = oVirt Provisioning Plugin
#
# Installs the ovirt_provision plugin
#
# === Parameters:
#
# $package:: Package name to install
#
class foreman::plugin::ovirt_provision (
  String $package = $::foreman::plugin::ovirt_provision::params::package,
) inherits foreman::plugin::ovirt_provision::params {
  foreman::plugin {'ovirt_provision':
    package => $package,
  }
}
