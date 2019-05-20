# = Hammer KubeVirt plugin
#
# This installs the KubeVirt plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::kubevirt {
  foreman::cli::plugin { 'foreman_kubevirt':
  }
}
