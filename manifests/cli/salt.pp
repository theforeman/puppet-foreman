# = Hammer foreman_salt plugin
#
# This installs the foreman_salt plugin for Hammer CLI
#
class foreman::cli::salt {
  foreman::cli::plugin { 'foreman_salt':
  }
}
