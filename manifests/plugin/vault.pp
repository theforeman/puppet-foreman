# = Foreman Vault plugin
#
# This class installs vault plugin
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::vault (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'vault':
    version => $ensure,
  }
}
