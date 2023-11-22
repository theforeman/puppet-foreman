# = Hammer foreman_rh_cloud plugin
#
# This installs the foreman_rh_cloud plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::rh_cloud {
  foreman::cli::plugin { 'foreman_rh_cloud':
  }
}
