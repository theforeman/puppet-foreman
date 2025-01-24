# = Foreman Statistics plugin
#
# This class installs trends and statistics plugin
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::statistics (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'statistics':
    version => $ensure,
  }
}
