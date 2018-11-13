# = Hammer Ansible plugin
#
# This installs the Ansible plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::ansible {
  foreman::cli::plugin { 'foreman_ansible':
  }
}
