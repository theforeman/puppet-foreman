# = Foreman VMware compute resource support
#
# Provides support for VMware compute resources
#
# === Advanced parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::vmware (String $version = 'installed') {
  package { 'foreman-vmware':
    ensure => $version,
    tag    => ['foreman-compute'],
  }
}
