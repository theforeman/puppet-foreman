# = Hammer SSH plugin
#
# This temporarily removes the SSH plugin package from existing installations.
# Remove this class after the grace period tracked in issue #1302.
#
# === Parameters:
#
class foreman::cli::ssh {
  foreman::cli::plugin { 'foreman_ssh':
    version => 'absent',
  }
}
