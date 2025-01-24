# Installs foreman_leapp plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::leapp (
  Optional[String[1]] $ensure = undef,
) {
  include foreman::plugin::remote_execution
  include foreman::plugin::ansible

  foreman::plugin { 'leapp':
    version => $ensure,
  }
}
