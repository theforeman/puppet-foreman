require_relative '../../puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_domain) do
  desc 'foreman_domain creates a domain in foreman.'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)
  instance_eval(&PuppetX::Foreman::Common::FOREMAN_DOMAIN_PARAMS)

end
