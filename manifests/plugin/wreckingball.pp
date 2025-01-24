# Installs foreman_wreckingball plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::wreckingball (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'wreckingball':
    version => $ensure,
  }
}
