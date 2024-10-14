# Installs foreman_ansible plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::ansible (
  Optional[String[1]] $ensure = undef,
) {
  include foreman::plugin::tasks

  foreman::plugin { 'ansible':
    version => $ensure,
  }
}
