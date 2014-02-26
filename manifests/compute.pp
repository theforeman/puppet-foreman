class foreman::compute {
  # A bunch of virtual packages for using in compute classes
  @package { ['foreman-compute',
              'foreman-gce',
              'foreman-libvirt',
              'foreman-ovirt',
              'foreman-vmware',
  ]:
    ensure => installed,
  }
}
