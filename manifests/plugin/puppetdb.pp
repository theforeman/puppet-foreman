# Installs puppetdb_foreman plugin
#
# === Parameters:
#
# $enabled::                Whether to enable the plugin
#
# $address::                URL of the puppetdb plugin should use to connect
#
class foreman::plugin::puppetdb(
  $enabled = true,
  $address = "https://puppetdb.${::domain}:8081/v2/commands",
) {
  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'fedora': {
          $package = 'rubygem-puppetdb_foreman'
        }
        default: {
          $package = 'ruby193-rubygem-puppetdb_foreman'
        }
      }
    }
    'Debian': {
      $package = 'ruby-puppetdb-foreman'
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          $package = 'ruby193-rubygem-puppetdb_foreman'
        }
        default: {
          fail("${::hostname}: puppetdb_foreman does not support operatingsystem ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("${::hostname}: puppetdb_foreman does not support osfamily ${::osfamily}")
    }
  }

  foreman::plugin {'puppetdb':
    package => $package,
    config  => template('foreman/puppetdb_plugin.yaml.erb'),
  }
}
