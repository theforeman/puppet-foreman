# foreman::providers default parameters
class foreman::providers::params {
  # Dependency packages for different providers supplied in this module
  $apipie_bindings = true
  $foreman_api = false

  # OS specific package names
  case $::osfamily {
    'RedHat': {
      $apipie_bindings_package = 'rubygem-apipie-bindings'
      $foreman_api_package = 'rubygem-foreman_api'
    }
    'Debian': {
      $apipie_bindings_package = 'ruby-apipie-bindings'
      $foreman_api_package = 'ruby-foreman-api'
    }
    'FreeBSD': {
      $apipie_bindings_package = 'rubygem-apipie-bindings'
      $foreman_api_package = 'rubygem-foreman_api'
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          $apipie_bindings_package = 'rubygem-apipie-bindings'
          $foreman_api_package = 'rubygem-foreman_api'
        }
        default: {
          fail("${::hostname}: This class does not support operatingsystem ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("${::hostname}: This class does not support osfamily ${::osfamily}")
    }
  }
}
