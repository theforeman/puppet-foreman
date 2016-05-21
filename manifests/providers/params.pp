# foreman::providers default parameters
class foreman::providers::params {
  # Dependency packages for different providers supplied in this module
  $oauth = true
  $json = (versioncmp($::rubyversion, '1.9') < 0)
  $apipie_bindings = false
  $foreman_api = false

  # OS specific package names
  case $::osfamily {
    'RedHat': {
      if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
        $oauth_package = 'puppet-agent-oauth'
      } else {
        $oauth_package = 'rubygem-oauth'
      }
      $json_package = 'rubygem-json'
      $apipie_bindings_package = 'rubygem-apipie-bindings'
      $foreman_api_package = 'rubygem-foreman_api'
    }
    'Debian': {
      if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
        $oauth_package = 'puppet-agent-oauth'
      } else {
        $oauth_package = 'ruby-oauth'
      }
      $json_package = 'ruby-json'
      $apipie_bindings_package = 'ruby-apipie-bindings'
      $foreman_api_package = 'ruby-foreman-api'
    }
    'FreeBSD': {
      $oauth_package = 'rubygem-oauth'
      $json_package = 'rubygem-json'
      $apipie_bindings_package = 'rubygem-apipie-bindings'
      $foreman_api_package = 'rubygem-foreman_api'
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
            $oauth_package = 'puppet-agent-oauth'
          } else {
            $oauth_package = 'rubygem-oauth'
          }
          $json_package = 'rubygem-json'
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
