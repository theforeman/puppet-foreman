# = Foreman Discovery plugin
#
# This class installs discovery plugin and images
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::discovery (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'discovery':
    version => $ensure,
  }
}
