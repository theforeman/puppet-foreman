# foreman::providers default parameters
class foreman::providers::params {
  # Dependency packages for different providers supplied in this module
  $oauth = true
  $apipie_bindings = false

  # OS specific package names
  case $::osfamily {
    'RedHat': {
      if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
        $oauth_package = 'puppet-agent-oauth'
      } else {
        $oauth_package = 'rubygem-oauth'
      }
      $apipie_bindings_package = 'rubygem-apipie-bindings'
    }
    'Debian': {
      if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
        $oauth_package = 'puppet-agent-oauth'
      } else {
        $oauth_package = 'ruby-oauth'
      }
      $apipie_bindings_package = 'ruby-apipie-bindings'
    }
    'FreeBSD': {
      $oauth_package = 'rubygem-oauth'
      $apipie_bindings_package = 'rubygem-apipie-bindings'
    }
    'Archlinux': {
      $oauth_package = 'ruby-oauth'
      $apipie_bindings_package = 'ruby-apipie-bindings'
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
            $oauth_package = 'puppet-agent-oauth'
          } else {
            $oauth_package = 'rubygem-oauth'
          }
          $apipie_bindings_package = 'rubygem-apipie-bindings'
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
