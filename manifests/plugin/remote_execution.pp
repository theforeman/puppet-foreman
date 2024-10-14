# Installs foreman_remote_execution plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::remote_execution (
  Optional[String[1]] $ensure = undef,
) {
  include foreman::plugin::tasks

  foreman::plugin { 'remote_execution':
    version => $ensure,
  }
}
