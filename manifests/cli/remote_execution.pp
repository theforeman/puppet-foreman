# = Hammer Remote Exeuction plugin
#
# This installs the Remote Exeuction plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::remote_execution {
  foreman::cli::plugin { 'foreman_remote_execution':
  }
}
