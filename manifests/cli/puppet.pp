# = Hammer Puppet plugin
#
# This installs the Puppet plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::puppet {
  foreman::cli::plugin { 'foreman_puppet':
  }
}
