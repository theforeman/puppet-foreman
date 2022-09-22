# @summary install the ovirt_provision plugin
class foreman::plugin::ovirt_provision {
  foreman::plugin { 'ovirt_provision':
    package => $foreman::params::plugin_prefix.regsubst(/foreman[_-]/, 'ovirt_provision_plugin'),
  }
}
