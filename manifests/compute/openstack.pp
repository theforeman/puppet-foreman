# = Foreman OpenStack compute resource support
#
# Provides support for OpenStack compute resources
#
# === Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::openstack($version = 'installed') {
  package { 'foreman-openstack':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
