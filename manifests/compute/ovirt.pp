# Provides support for oVirt compute resources
#
# === Advanced Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::ovirt(String $version = 'installed') {
  package { 'foreman-ovirt':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
