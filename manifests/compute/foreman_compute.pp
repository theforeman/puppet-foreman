# Provides a common class to install foreman-compute
# used by multiple compute resources
#
# === Advanced Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::foreman_compute(String $version = 'installed') {
  package { 'foreman-compute':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
