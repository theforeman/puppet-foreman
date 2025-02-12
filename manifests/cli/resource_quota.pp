# = Hammer foreman_resource_quota plugin
#
# This installs the foreman_resource_quota plugin for Hammer CLI
#
class foreman::cli::resource_quota {
  foreman::cli::plugin { 'foreman_resource_quota':
  }
}
