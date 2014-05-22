class foreman::plugin::puppetdb(
  $enabled = $foreman::plugin::puppetdb::params::enabled,
  $address = $foreman::plugin::puppetdb::params::address,
) inherits foreman::plugin::puppetdb::params {
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
      $package = 'ruby-puppetdb_foreman'
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
