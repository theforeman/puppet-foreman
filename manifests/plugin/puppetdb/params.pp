# Data for the puppetdb_foreman plugin
class foreman::plugin::puppetdb::params {
  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'fedora': {
          $package = 'rubygem-puppetdb_foreman'
        }
        default: {
          $package = 'tfm-rubygem-puppetdb_foreman'
        }
      }
    }
    'Debian': {
      $package = 'ruby-puppetdb-foreman'
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          $package = 'tfm-rubygem-puppetdb_foreman'
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
}
