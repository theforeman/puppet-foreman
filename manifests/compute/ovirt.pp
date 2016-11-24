# = Foreman oVirt compute resource support
#
# Provides support for oVirt compute resources
#
# === Parameters:
#
# $version::  Package version to install, defaults to installed
#             type:String
#
class foreman::compute::ovirt ( $version = 'installed' ) {
  package { 'foreman-ovirt':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
