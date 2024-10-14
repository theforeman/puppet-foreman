# Installs foreman_salt plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::salt (
  Optional[String[1]] $ensure = undef,
) {
  include foreman::plugin::tasks

  foreman::plugin { 'salt':
    version => $ensure,
  }
}
