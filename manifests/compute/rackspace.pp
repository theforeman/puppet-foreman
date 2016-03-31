# = Foreman Rackspace compute resource support
#
# Provides support for Rackspace compute resources
#
# === Parameters:
#
# $version::  Package version to install, defaults to installed
#
# $package::  Package name to install, use foreman-compute on Foreman 1.11 or older
#
class foreman::compute::rackspace($package = 'foreman-rackspace', $version = 'installed') {
  if $package == 'foreman-compute' {
    include ::foreman::compute::foreman_compute
  } else {
    package { $package:
      ensure => $version,
      tag    => [ 'foreman-compute', ],
    }
  }
}
