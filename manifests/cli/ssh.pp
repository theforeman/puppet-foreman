# = Hammer SSH plugin
#
# This installs the SSH plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::ssh {
  foreman::cli::plugin { 'foreman_ssh':
  }
}
