# Defines virtual resources for potentially shared compute resource packages
class foreman::compute {
  # A bunch of virtual packages for using in compute classes
  @package { ['foreman-compute',
              'foreman-ec2',
              'foreman-gce',
              'foreman-libvirt',
              'foreman-ovirt',
              'foreman-vmware',
  ]:
    ensure => installed,
  }
}
