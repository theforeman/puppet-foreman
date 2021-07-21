# Parameters for Foreman CLI class
class foreman::cli::params inherits foreman::cli::globals {
  $foreman_url = undef
  $version = 'installed'
  $manage_root_config = true
  $username = undef
  $password = undef
  $refresh_cache = false
  $request_timeout = 120
  $use_sessions = false
  $ssl_ca_file = undef

  # OS specific paths
  case $facts['os']['family'] {
    'RedHat': {
      # We use system packages except on EL7
      if versioncmp($facts['os']['release']['major'], '8') >= 0 {
        $_hammer_plugin_prefix = 'rubygem-hammer_cli_'
      } else {
        $_hammer_plugin_prefix = 'tfm-rubygem-hammer_cli_'
      }
    }
    'Debian': {
      $_hammer_plugin_prefix = 'ruby-hammer-cli-'
    }
    'Linux': {
      case $facts['os']['name'] {
        'Amazon': {
          $_hammer_plugin_prefix = 'tfm-rubygem-hammer_cli_'
        }
        default: {
          fail("${facts['networking']['hostname']}: This module does not support operatingsystem ${facts['os']['name']}")
        }
      }
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
