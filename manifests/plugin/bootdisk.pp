# Installs foreman_bootdisk plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::bootdisk (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'bootdisk':
    version => $ensure,
  }
}
