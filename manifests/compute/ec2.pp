# Provides support for EC2 compute resources
#
# === Advanced Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::ec2(String $version = 'installed') {
  package { 'foreman-ec2':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
