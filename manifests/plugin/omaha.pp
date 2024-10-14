# Installs foreman_omaha plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::omaha (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'omaha':
    version => $ensure,
  }
}
