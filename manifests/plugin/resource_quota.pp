# Installs foreman_resource_quota plugin
class foreman::plugin::resource_quota {
  include foreman::plugin::tasks

  foreman::plugin { 'resource_quota':
  }
}
