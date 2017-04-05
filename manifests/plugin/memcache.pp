# = Foreman Memcache plugin
#
# This class installs the memcache plugin and configuration file
#
# === Parameters:
#
# $hosts::      an array of hosts running memcache
#
# $expires_in:: global default for key TTL in seconds
#
# $namespace::  prepends each key with this value to provide simple namespacing
#
# $compress::   will gzip-compress values larger than 1K
#
class foreman::plugin::memcache (
  Array[String] $hosts = $::foreman::plugin::memcache::params::hosts,
  Integer[0] $expires_in = $::foreman::plugin::memcache::params::expires_in,
  String $namespace = $::foreman::plugin::memcache::params::namespace,
  Boolean $compress = $::foreman::plugin::memcache::params::compress,
) inherits foreman::plugin::memcache::params {
  foreman::plugin {'memcache':
    config => template('foreman/foreman_memcache.yaml.erb'),
  }
}
