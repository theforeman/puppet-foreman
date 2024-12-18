# Installs foreman_google plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::google (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'google':
    version => $ensure,
  }
}
