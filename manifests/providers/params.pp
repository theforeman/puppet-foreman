# foreman::providers default parameters
class foreman::providers::params {
  # Dependency packages for different providers supplied in this module
  $oauth = true

  # OS specific package names
  case $::osfamily {
    'RedHat': {
      if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
        $oauth_package = 'puppet-agent-oauth'
      } else {
        $oauth_package = 'rubygem-oauth'
      }
    }
    'Debian': {
      if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
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
      case $::operatingsystem {
        'Amazon': {
          if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
            $oauth_package = 'puppet-agent-oauth'
          } else {
            $oauth_package = 'rubygem-oauth'
          }
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
