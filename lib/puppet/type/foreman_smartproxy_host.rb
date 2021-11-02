require_relative '../../puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_smartproxy_host) do
  desc 'foreman_smartproxy_host marks a host as a smart proxy.'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)
  instance_eval(&PuppetX::Foreman::Common::FOREMAN_HOST_PARAMS)

  autorequire(:foreman_host) do
    [self[:name]]
  end

  autorequire(:foreman_smartproxy) do
    [self[:hostname]]
  end
end
