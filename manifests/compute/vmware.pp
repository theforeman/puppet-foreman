# Provides support for VMware compute resources
class foreman::compute::vmware {
  realize Package['foreman-vmware']
}
