# Installs foreman_azure_rm plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::azure (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'azure_rm':
    version => $ensure,
  }
}
