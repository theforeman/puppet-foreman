# @summary foreman::providers default parameters
# @api private
class foreman::providers::params {
  # Dependency packages for different providers supplied in this module
  $is_aio = fact('aio_agent_version') =~ String[1]

  # OS specific package names
  case $facts['os']['family'] {
    'RedHat': {
      if $is_aio {
        $oauth_package = 'puppet-agent-oauth'
      } else {
        $oauth_package = 'rubygem-oauth'
      }
    }
    'Debian': {
      if $is_aio {
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
    default: {
      fail("${facts['networking']['hostname']}: This class does not support osfamily ${facts['os']['family']}")
    }
  }
}
