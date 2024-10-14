# Installs foreman_templates plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::templates (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'templates':
    version => $ensure,
  }
}
