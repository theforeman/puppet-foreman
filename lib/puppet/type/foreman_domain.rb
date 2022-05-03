require_relative '../../puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_domain) do
  desc 'foreman_domain creates a domain in foreman.'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)

  newparam(:name, :namevar => true) do
    desc 'The name of the domain resource.'
  end

  newparam(:fullname) do
    desc 'The name/description of the domain.'
  end

  newparam(:dns_id) do
    desc 'DNS Smart Proxy ID.'
  end
end
