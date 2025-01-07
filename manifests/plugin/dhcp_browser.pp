# Installs foreman_dhcp_browser plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::dhcp_browser (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'dhcp_browser':
    version => $ensure,
  }
}
