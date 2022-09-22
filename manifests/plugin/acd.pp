# Installs foreman_acd plugin
class foreman::plugin::acd {
  include foreman::plugin::tasks
  include foreman::plugin::remote_execution

  foreman::plugin { 'acd':
  }
}
