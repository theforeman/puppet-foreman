# foreman::providers default parameters
class foreman::providers::params {
  # Dependency packages for different providers supplied in this module
  $oauth = true

  # OS specific package names
  case $facts['os']['family'] {
    'RedHat': {
      if $facts['ruby']['sitedir'] =~ /\/opt\/puppetlabs\/puppet/ {
        $oauth_package = 'puppet-agent-oauth'
      } else {
        $oauth_package = 'rubygem-oauth'
      }
    }
    'Debian': {
      if $facts['ruby']['sitedir'] =~ /\/opt\/puppetlabs\/puppet/ {
        $oauth_package = 'puppet-agent-oauth'
      } else {
        $oauth_package = 'ruby-oauth'
      }
    }
    'FreeBSD': {
      $oauth_package = 'rubygem-oauth'
    }
    'Archlinux': {
      $oauth_package = 'ruby-oauth'
    }
    'Linux': {
      case $facts['os']['name'] {
        'Amazon': {
          if $facts['ruby']['sitedir'] =~ /\/opt\/puppetlabs\/puppet/ {
            $oauth_package = 'puppet-agent-oauth'
          } else {
            $oauth_package = 'rubygem-oauth'
          }
        }
        default: {
          fail("${facts['networking']['hostname']}: This class does not support operatingsystem ${facts['os']['name']}")
        }
      }
    }
    default: {
      fail("${facts['networking']['hostname']}: This class does not support osfamily ${facts['os']['family']}")
    }
  }
}
