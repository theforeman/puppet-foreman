# Installs ovirt_provision plugin
class foreman::plugin::ovirt_provision {
  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'fedora': {
          $package = 'rubygem-ovirt_provision_plugin'
        }
        default: {
          $package = 'ruby193-rubygem-ovirt_provision_plugin'
        }
      }
    }
    'Debian': {
      $package = 'ruby-ovirt-provision-plugin'
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          $package = 'ruby193-ovirt_provision_plugin'
        }
        default: {
          fail("${::hostname}: ovirt_provision_plugin does not support operatingsystem ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("${::hostname}: ovirt_provision_plugin does not support osfamily ${::osfamily}")
    }
  }

  foreman::plugin {'ovirt_provision':
    package => $package,
  }
}
