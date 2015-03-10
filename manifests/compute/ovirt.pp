# Provides support for oVirt compute resources
#
# === Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::ovirt ( $version = 'installed' ) {
  package { 'foreman-ovirt':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
