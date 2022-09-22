require_relative '../../puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_instance_host) do
  desc 'foreman_instance_host marks a host as belonging to the set of hosts that make up the Foreman instance/application'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)
  instance_eval(&PuppetX::Foreman::Common::FOREMAN_HOST_PARAMS)

  autorequire(:foreman_host) do
    [self[:name]]
  end
end
