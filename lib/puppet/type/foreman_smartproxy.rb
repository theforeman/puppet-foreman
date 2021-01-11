Puppet::Type.newtype(:foreman_smartproxy) do
  desc 'foreman_smartproxy registers a smartproxy in foreman.'

  feature :feature_validation, "Enabled features can be validated", methods: [:features, :features=]

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the smartproxy.'
  end

  newparam(:base_url) do
    desc 'Foreman\'s base url.'
  end

  newparam(:effective_user) do
    desc 'Foreman\'s effective user for the registration (usually admin).'
  end

  newparam(:consumer_key) do
    desc 'Foreman oauth consumer_key'
  end

  newparam(:consumer_secret) do
    desc 'Foreman oauth consumer_secret'
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

  newparam(:ssl_ca) do
    desc 'Foreman SSL CA (certificate authority) for verification'
  end

  newproperty(:url) do
    desc 'The url of the smartproxy'
    isrequired
    newvalues(URI.regexp)
  end

  newparam(:instance_id) do
    desc 'Instance id of the smartproxy'
  end

  newparam(:timeout) do
    desc "Timeout for HTTP(s) requests"

    munge do |value|
      value = value.shift if value.is_a?(Array)
      begin
        value = Integer(value)
      rescue ArgumentError
        raise ArgumentError, "The timeout must be a number.", $!.backtrace
      end
      [value, 0].max
    end

    defaultto 500
  end

  def refresh
    if @parameters[:ensure].retrieve == :present
      provider.refresh_features! if provider.respond_to?(:refresh_features!)
    else
      debug 'Skipping refresh; smart proxy is not registered'
    end
  end

end
