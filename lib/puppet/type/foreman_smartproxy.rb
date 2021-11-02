require_relative '../../puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_smartproxy) do
  desc 'foreman_smartproxy registers a smartproxy in foreman.'

  feature :feature_validation, "Enabled features can be validated", methods: [:features, :features=]

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)

  newparam(:name, :namevar => true) do
    desc 'The name of the smartproxy.'
  end

  newproperty(:features, required_features: :feature_validation, array_matching: :all) do
    desc 'Features expected to be enabled on the smart proxy. Setting this
      validates that all of the listed features are functional, according to
      the list of enabled features returned when registering or refreshing the
      smart proxy.'
    defaultto []

    def insync?(current)
      (@should.sort - current.sort).empty?
    end

    def is_to_s(value)
      "[#{value.sort.map(&:inspect).join(', ')}]"
    end
    alias should_to_s is_to_s
  end

  newproperty(:url) do
    desc 'The url of the smartproxy'
    isrequired
    newvalues(URI.regexp)
  end

  def refresh
    if @parameters[:ensure].retrieve == :present
      provider.refresh_features! if provider.respond_to?(:refresh_features!)
    else
      debug 'Skipping refresh; smart proxy is not registered'
    end
  end
end
