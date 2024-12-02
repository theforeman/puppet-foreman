# Installs foreman_acd plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::acd (
  Optional[String[1]] $ensure = undef,
) {
  include foreman::plugin::tasks
  include foreman::plugin::remote_execution

  foreman::plugin { 'acd':
    version => $ensure,
  }
}
