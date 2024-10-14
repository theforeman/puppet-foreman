# = Foreman Puppet plugin
#
# This class installs puppet plugin
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::puppet (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'puppet':
    version => $ensure,
  }
}
