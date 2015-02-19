# Installs foreman-tasks plugin
class foreman::plugin::tasks {
  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'fedora': {
          $package = 'rubygem-foreman-tasks'
        }
        default: {
          $package = 'ruby193-rubygem-foreman-tasks'
        }
      }
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
  }
}
