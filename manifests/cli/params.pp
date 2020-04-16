# Parameters for Foreman CLI class
class foreman::cli::params {
  $foreman_url = undef
  $version = 'installed'
  $manage_root_config = true
  $username = undef
  $password = undef
  $refresh_cache = false
  $request_timeout = 120
  $ssl_ca_file = undef

  # OS specific paths
  case $facts['os']['family'] {
    'RedHat': {
      # We use system packages except on EL7
      if versioncmp($facts['os']['release']['major'], '8') >= 0 {
        $hammer_plugin_prefix = 'rubygem-hammer_cli_'
      } else {
        $hammer_plugin_prefix = 'tfm-rubygem-hammer_cli_'
      }
    }
    'Debian': {
      $hammer_plugin_prefix = 'ruby-hammer-cli-'
    }
    'Linux': {
      case $facts['os']['name'] {
        'Amazon': {
          $hammer_plugin_prefix = 'tfm-rubygem-hammer_cli_'
        }
        default: {
          fail("${facts['networking']['hostname']}: This module does not support operatingsystem ${facts['os']['name']}")
        }
      }
    }
    /(ArchLinux|Suse)/: {
      $hammer_plugin_prefix = undef
    }
    /^(FreeBSD|DragonFly)$/: {
      $hammer_plugin_prefix = undef
    }
    'windows': {
      $hammer_plugin_prefix = undef
    }
    default: {
      fail("${facts['networking']['hostname']}: This module does not support osfamily ${facts['os']['family']}")
    }
  }
}
