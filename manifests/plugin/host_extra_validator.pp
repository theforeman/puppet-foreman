# Installs foreman_host_extra_validator plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::host_extra_validator (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'host_extra_validator':
    version => $ensure,
  }
}
