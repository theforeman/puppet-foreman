# = Foreman Tasks
#
# Installs the foreman-tasks plugin
#
# === Parameters:
#
# $package:: Package name to install, use ruby193-rubygem-foreman-tasks on Foreman 1.8/1.9 on EL
#
# $service:: Service name
#
# $automatic_cleanup:: Enable automatic task cleanup using a cron job
#
class foreman::plugin::tasks(
  String  $package = $::foreman::plugin::tasks::params::package,
  String  $service = $::foreman::plugin::tasks::params::service,
  Boolean $automatic_cleanup = $::foreman::plugin::tasks::params::automatic_cleanup,
) inherits foreman::plugin::tasks::params {
  foreman::plugin { 'tasks':
    package => $package,
  }
  ~> service { 'foreman-tasks':
    ensure => running,
    enable => true,
    name   => $service,
  }
  $cron_content = @(END)
             SHELL=/bin/sh
             RAILS_ENV=production
             FOREMAN_HOME=/usr/share/foreman

             # Clean up expired tasks from the database
             45 19 * * *     foreman    /usr/sbin/foreman-rake foreman_tasks:cleanup >>/var/log/foreman/cron.log 2>&1
             | END
  file { 'foreman-tasks-cleanup-cron':
    ensure  => if $automatic_cleanup {
      present
    } else {
      absent
    },
    owner   => 'root',
    path    => '/etc/cron.d/foreman-tasks-cleanup',
    content => $cron_content,
  }
}
