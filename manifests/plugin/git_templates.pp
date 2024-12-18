# = Foreman Git Templates plugin
#
# This class installs git_templates plugin
#
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::git_templates (
  Optional[String[1]] $ensure = undef,
) {
  foreman::plugin { 'git_templates':
    version => $ensure,
  }
}
