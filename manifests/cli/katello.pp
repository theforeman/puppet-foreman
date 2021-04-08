# = Hammer Katello plugin
#
# This installs the Katello plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::katello {
  foreman::cli::plugin { 'katello':
  }
}
