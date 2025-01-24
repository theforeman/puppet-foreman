# = Foreman Netbox plugin
#
# This class installs netbox plugin
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::netbox (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'netbox':
    version => $ensure,
  }
}
