# @summary Install the foreman-tasks plugin
#
# @param automatic_cleanup
#   Enable automatic task cleanup using a cron job
#
# @param cron_line
#   Cron line defining when the cleanup cron job should run
#
# @param backup
#   Enable creating a backup of cleaned up tasks in CSV format when automatic_cleanup is enabled
#
class foreman::plugin::tasks(
  Boolean $automatic_cleanup = false,
  String $cron_line = '45 19 * * *',
  Boolean $backup = false,
) {
  foreman::plugin { 'tasks':
    package => $foreman::params::plugin_prefix.regsubst(/foreman[_-]/, 'foreman-tasks'),
  }
  $cron_state = $automatic_cleanup ? {
    true    => 'file',
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
