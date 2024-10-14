# @summary install the ovirt_provision plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::ovirt_provision (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'ovirt_provision':
    version => $ensure,
    package => $foreman::params::plugin_prefix.regsubst(/foreman[_-]/, 'ovirt_provision_plugin'),
  }
}
