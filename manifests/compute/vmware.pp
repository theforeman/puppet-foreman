# Provides support for VMware compute resources
#
# === Advanced Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::vmware(String $version = 'installed') {
  package { 'foreman-vmware':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
