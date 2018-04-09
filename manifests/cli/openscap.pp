# = Hammer OpenSCAP plugin
#
# This installs the OpenSCAP plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::openscap {
  foreman::cli::plugin { 'foreman_openscap':
  }
}
