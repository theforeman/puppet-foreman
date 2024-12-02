# Installs foreman_rescue plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::rescue (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'rescue':
    version => $ensure,
  }
}
