# Provides support for Google Compute Engine compute resources
#
# === Advanced Parameters:
#
# $version::  Package version to install, defaults to installed
#
class foreman::compute::gce(String $version = 'installed') {
  package { 'foreman-gce':
    ensure => $version,
    tag    => [ 'foreman-compute', ],
  }
}
