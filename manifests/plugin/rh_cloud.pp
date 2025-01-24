# Installs rh_cloud plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::rh_cloud (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'rh_cloud':
    version => $ensure,
  }
}
