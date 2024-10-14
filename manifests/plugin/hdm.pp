# @summary Install the Hiera Data Manager (HDM) plugin
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::hdm (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'hdm':
    version => $ensure,
  }
}
