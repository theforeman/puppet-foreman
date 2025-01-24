# Installs foreman_dlm plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::dlm (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'dlm':
    version => $ensure,
  }
}
