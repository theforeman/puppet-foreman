# = Hammer Tasks plugin
#
# This installs the Tasks plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::tasks {
  foreman::cli::plugin { 'foreman_tasks':
  }
}
