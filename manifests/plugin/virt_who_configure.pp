# Installs foreman_virt_who_configure plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::virt_who_configure (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'virt_who_configure':
    version => $ensure,
  }
}
