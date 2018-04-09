# = Hammer Discovery plugin
#
# This installs the Discovery plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::discovery {
  foreman::cli::plugin { 'foreman_discovery':
  }
}
