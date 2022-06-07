# @summary Parameters for Foreman CLI class
# @api private
class foreman::cli::params inherits foreman::cli::globals {
  # OS specific paths
  case $facts['os']['family'] {
    'RedHat': {
      $_hammer_plugin_prefix = 'rubygem-hammer_cli_'
    }
    'Debian': {
      $_hammer_plugin_prefix = 'ruby-hammer-cli-'
    }
    /(ArchLinux|Suse)/: {
      $_hammer_plugin_prefix = undef
    }
    /^(FreeBSD|DragonFly)$/: {
      $_hammer_plugin_prefix = undef
    }
    'windows': {
      $_hammer_plugin_prefix = undef
    }
    default: {
      fail("${facts['networking']['hostname']}: This module does not support osfamily ${facts['os']['family']}")
    }
  }
  $hammer_plugin_prefix = pick($foreman::cli::globals::hammer_plugin_prefix, $_hammer_plugin_prefix)
}
