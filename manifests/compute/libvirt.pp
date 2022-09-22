# = Foreman LibVirt compute resource support
#
# Provides support for Libvirt compute resources
#
# === Advanced parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::libvirt (String $version = 'installed') {
  package { 'foreman-libvirt':
    ensure => $version,
    tag    => ['foreman-compute'],
  }
}
