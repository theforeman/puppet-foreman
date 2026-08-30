require_relative '../../puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_subnet) do
  desc 'foreman_subnet creates a subnet in foreman.'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)
  instance_eval(&PuppetX::Foreman::Common::FOREMAN_SUBNET_PARAMS)

end
