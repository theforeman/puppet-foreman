# = Foreman Leapp plugin
#
# Installs foreman_leapp plugin
#
class foreman::plugin::leapp {
  include foreman::plugin::remote_execution
  include foreman::plugin::ansible

  foreman::plugin {'leapp':
  }
}
