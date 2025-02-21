# = Hammer foreman_scc_manager plugin
#
# This installs the foreman_scc_manager plugin for Hammer CLI
#
class foreman::cli::scc_manager {
  foreman::cli::plugin { 'foreman_scc_manager':
  }
}
