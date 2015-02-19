# = Foreman EC2 compute resource support
#
# Provides support for EC2 compute resources
#
# === Parameters:
#
# $package::  Package name to install, use foreman-compute on Foreman 1.7
#
class foreman::compute::ec2($package = 'foreman-ec2') {
  realize Package[$package]
}
