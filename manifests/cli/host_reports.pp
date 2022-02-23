# = Hammer Host Reports plugin
#
# This installs the Host Reports plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::host_reports {
  foreman::cli::plugin { 'foreman_host_reports':
  }
}
