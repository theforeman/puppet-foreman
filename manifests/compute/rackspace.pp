# Provides support for Rackspace compute resources
#
# === Advanced Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::rackspace(String $version = 'installed') {
  package { 'foreman-rackspace':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
