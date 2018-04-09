# = Hammer Templates plugin
#
# This installs the Templates plugin for Hammer CLI
#
# === Parameters:
#
class foreman::cli::templates {
  foreman::cli::plugin { 'foreman_templates':
  }
}
