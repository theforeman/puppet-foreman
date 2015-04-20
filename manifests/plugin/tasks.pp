# Installs foreman-tasks plugin
class foreman::plugin::tasks {
  case $::osfamily {
    'RedHat': {
      $service = 'foreman-tasks'
      case $::operatingsystem {
        'fedora': {
          $package = 'rubygem-foreman-tasks'
        }
        default: {
          $package = 'ruby193-rubygem-foreman-tasks'
        }
      }
    }
    'Debian': {
      $package = 'ruby-foreman-tasks'
      $service = 'ruby-foreman-tasks'
    }
    default: {
      fail("${::hostname}: foreman-tasks does not support osfamily ${::osfamily}")
    }
  }

  foreman::plugin { 'tasks':
    package => $package,
  } ~>
  service { 'foreman-tasks':
    ensure => running,
    enable => true,
    name   => $service,
  }
}
