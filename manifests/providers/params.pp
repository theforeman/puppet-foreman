# @summary foreman::providers default parameters
# @api private
class foreman::providers::params {
  # Dependency packages for different providers supplied in this module
  $is_aio = fact('aio_agent_version') =~ String[1]

  # OS specific package names
  case $facts['os']['family'] {
    'RedHat': {
      $oauth_package = if $is_aio {
        'puppet-agent-oauth'
      } else {
        'rubygem-oauth'
      }
    }
    'Debian': {
      $oauth_package = if $is_aio {
        'puppet-agent-oauth'
      } else {
        'ruby-oauth'
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
