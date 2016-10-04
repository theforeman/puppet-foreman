# = Foreman Tasks
#
# Installs the foreman-tasks plugin
#
# === Parameters:
#
# $package::        Package name to install, use ruby193-rubygem-foreman-tasks on Foreman 1.8/1.9 on EL
#                   type:String
#
# $service::        Service name
#                   type:String
#
# $manage_config::  If we should manage the config file fore foreman-tasks. Defaults to false
#                   type:Boolean
#
# $logger_dynflow:: Logging configuration for dynflow. Defaults to true
#                   type:Boolean
#
# $logger_action::  Logging configuration for action. Defaults to true
#                   type:Boolean
#
# $cleanup_after::  Cleaning configuration: how long should the actions be kept before deleted
#                   by `rake foreman_tasks:clean` task. Defaults to undef
#                   type:String
#
class foreman::plugin::tasks (
  $package        = $foreman::plugin::tasks::params::package,
  $service        = $foreman::plugin::tasks::params::service,
  $manage_config  = $foreman::plugin::tasks::params::manage_config,
  $logger_dynflow = $foreman::plugin::tasks::params::logger_dynflow,
  $logger_action  = $foreman::plugin::tasks::params::logger_action,
  $cleanup_after  = $foreman::plugin::tasks::params::cleanup_after,
) inherits foreman::plugin::tasks::params {
  if $manage_config {
    $config = template('foreman/foreman-tasks.yaml.erb')
  } else {
    $config = undef
  }

  foreman::plugin { 'tasks':
    package     => $package,
    config_file => "${foreman::plugin_config_dir}/foreman-tasks.yaml",
    config      => $config,
  } ~>
  service { 'foreman-tasks':
    ensure => running,
    enable => true,
    name   => $service,
  }
}
