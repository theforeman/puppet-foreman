# Data for the foreman-tasks plugin
class foreman::plugin::tasks::params {
  $automatic_cleanup = false
  $cron_line = '45 19 * * *'
  case $::osfamily {
    'RedHat': {
      # We use system packages except on EL7
      if versioncmp($facts['operatingsystemmajrelease'], '8') >= 0 {
        $package = 'rubygem-foreman-tasks'
      } else {
        $package = 'tfm-rubygem-foreman-tasks'
      }
    }
    'Debian': {
      $package = 'ruby-foreman-tasks'
    }
    /^(FreeBSD|DragonFly)$/: {
      # do nothing to not break foreman-installer
    }
    default: {
      fail("${::hostname}: foreman-tasks does not support osfamily ${::osfamily}")
    }
  }
}
