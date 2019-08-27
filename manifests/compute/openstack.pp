# Provides support for OpenStack compute resources
#
# === Advanced Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::openstack(String $version = 'installed') {
  package { 'foreman-openstack':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
