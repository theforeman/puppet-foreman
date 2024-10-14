# Installs foreman_kernel_care plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::kernel_care (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'kernel_care':
    version => $ensure,
  }
}
