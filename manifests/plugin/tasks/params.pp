# Data for the foreman-tasks plugin
class foreman::plugin::tasks::params {
  $manage_config  = false
  $logger_dynflow = true
  $logger_action  = true
  $cleanup_after  = undef

  case $::osfamily {
    'RedHat': {
      $service = 'foreman-tasks'
      case $::operatingsystem {
        'fedora': {
          $package = 'rubygem-foreman-tasks'
        }
        default: {
          $package = 'tfm-rubygem-foreman-tasks'
        }
      }
    }
    'Debian': {
      $package = 'ruby-foreman-tasks'
      $service = 'ruby-foreman-tasks'
    }
    /^(FreeBSD|DragonFly)$/: {
      # do nothing to not break foreman-installer
    }
    default: {
      fail("${::hostname}: foreman-tasks does not support osfamily ${::osfamily}")
    }
  }
}
