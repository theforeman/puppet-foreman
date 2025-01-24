# Installs foreman_snapshot_management plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::snapshot_management (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'snapshot_management':
    version => $ensure,
  }
}
