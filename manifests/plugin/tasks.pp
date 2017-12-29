# = Foreman Tasks
#
# Installs the foreman-tasks plugin
#
# === Parameters:
#
# $package:: Package name to install, use ruby193-rubygem-foreman-tasks on Foreman 1.8/1.9 on EL
#
# $automatic_cleanup:: Enable automatic task cleanup using a cron job
#
# $cron_line:: Cron line defining when the cleanup cron job should run
#
class foreman::plugin::tasks(
  String $package = $::foreman::plugin::tasks::params::package,
  Boolean $automatic_cleanup = $::foreman::plugin::tasks::params::automatic_cleanup,
  String $cron_line = $::foreman::plugin::tasks::params::cron_line,
) inherits foreman::plugin::tasks::params {
  include ::foreman::service::jobs

  foreman::plugin { 'tasks':
    package => $package,
    notify  => Class['foreman::service::jobs'],
  }
  $cron_state = $automatic_cleanup ? {
    true    => 'present',
    default => 'absent',
  }
  file { '/etc/cron.d/foreman-tasks':
    ensure  => $cron_state,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('foreman/tasks.cron.erb'),
  }
}
