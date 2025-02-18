# = Hammer foreman_bootdisk plugin
#
# This installs the foreman_bootdisk plugin for Hammer CLI
#
class foreman::cli::bootdisk {
  foreman::cli::plugin { 'foreman_bootdisk':
  }
}
