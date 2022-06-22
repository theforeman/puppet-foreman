# = Foreman OpenStack compute resource support
#
# Provides support for OpenStack compute resources
#
# === Advanced parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::openstack (String $version = 'installed') {
  package { 'foreman-openstack':
    ensure => $version,
    tag    => ['foreman-compute',],
  }
}
