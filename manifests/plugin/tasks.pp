# = Foreman Tasks plugin
#
# Install the foreman-tasks plugin
#
# === Advanced parameters:
#
# $automatic_cleanup::   Enable automatic task cleanup using a cron job
#
# $cron_line::   Cron line defining when the cleanup cron job should run
#
class foreman::plugin::tasks(
  Boolean $automatic_cleanup = false,
  String $cron_line = '45 19 * * *',
) {
  foreman::plugin { 'tasks':
    package => $foreman::plugin_prefix.regsubst(/foreman[_-]/, 'foreman-tasks'),
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
