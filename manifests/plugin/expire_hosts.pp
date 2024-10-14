# Installs foreman_expire_hosts plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::expire_hosts (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'expire_hosts':
    version => $ensure,
  }
}
