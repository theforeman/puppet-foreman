# Installs foreman_datacenter plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::datacenter (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'datacenter':
    version => $ensure,
  }
}
