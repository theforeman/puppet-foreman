# @summary Installs rh_cloud plugin
#
# @param enable_iop_advisor_engine
#   Enable iop-advisor-engine integration
#
class foreman::plugin::rh_cloud (
  Boolean $enable_iop_advisor_engine = false,
) {
  foreman::plugin { 'rh_cloud':
    config => epp('foreman/rh_cloud.yaml.epp', { 'enable_iop_advisor_engine' => $enable_iop_advisor_engine }),
  }

  class { 'iop_advisor_engine':
    ensure => bool2str($enable_iop_advisor_engine, 'present', 'absent'),
  }
}
