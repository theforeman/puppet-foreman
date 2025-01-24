# = Foreman OpenSCAP plugin
#
# This class installs OpenSCAP plugin
#
# === Parameters:
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::openscap (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'openscap':
    version => $ensure,
  }
}
