# = Foreman Rackspace compute resource support
#
# Provides support for Rackspace compute resources
#
# === Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::rackspace(String $version = 'installed') {
  package { 'foreman-rackspace':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
