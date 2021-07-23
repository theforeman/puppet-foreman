# = Hammer Webhooks plugin
#
# This installs the Webhooks plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::webhooks {
  foreman::cli::plugin { 'foreman_webhooks':
  }
}
