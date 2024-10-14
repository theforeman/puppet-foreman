# Installs foreman_monitoring plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::monitoring (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'monitoring':
    version => $ensure,
  }
}
