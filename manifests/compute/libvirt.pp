# Provides support for Libvirt compute resources
class foreman::compute::libvirt {
  realize Package['foreman-libvirt']
}
