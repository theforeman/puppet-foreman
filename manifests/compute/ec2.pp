# Provides support for EC2 compute resources
class foreman::compute::ec2 {
  realize Package['foreman-compute']
}
