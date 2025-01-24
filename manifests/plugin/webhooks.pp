# = Foreman Webhooks plugin
#
# This class installs webhooks plugin
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::webhooks (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'webhooks':
    version => $ensure,
  }
}
