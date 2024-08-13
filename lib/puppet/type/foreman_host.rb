require_relative '../../puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_host) do
  desc 'foreman_host creates a host in foreman.'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)
  instance_eval(&PuppetX::Foreman::Common::FOREMAN_HOST_PARAMS)

  newparam(:facts) do
    desc 'Hash of facts about the host'

    defaultto { $facts }
  end

  newparam(:force_fact_upload) do
    desc 'Force fact upload when host already exists'
  end
end
