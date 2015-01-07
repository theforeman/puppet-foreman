# = Foreman EC2 compute resource support
#
# Provides support for EC2 compute resources
#
# === Parameters:
#
# $version::  Package version to install, defaults to installed
#
# $package::  Package name to install, use foreman-compute on Foreman 1.7
#
class foreman::compute::ec2($package = 'foreman-ec2', $version = 'installed') {
  if $package == 'foreman-compute' {
    include ::foreman::compute::foreman_compute
  } else {
    package { $package:
      ensure => $version,
      tag    => [ 'foreman-compute', ],
    }
  }
}
