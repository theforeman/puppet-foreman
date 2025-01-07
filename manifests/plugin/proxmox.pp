# = Foreman Proxmox plugin
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::proxmox (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'fog_proxmox':
    version => $ensure,
  }
}
