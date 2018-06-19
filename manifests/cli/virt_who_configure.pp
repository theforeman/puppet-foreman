# = Hammer Virt Who Configure plugin
#
# This installs the Virt Who Configure plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::virt_who_configure {
  foreman::cli::plugin { 'foreman_virt_who_configure':
  }
}
