# = Foreman SCC Manager plugin
#
# This class installs scc_manager plugin
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::scc_manager (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'scc_manager':
    version => $ensure,
  }
}
