Puppet::Type.newtype(:foreman_smartproxy) do
  desc 'foreman_smartproxy registers a smart proxy in foreman.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the smart proxy.'
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

  newparam(:ssl_ca) do
    desc 'Foreman SSL CA (certificate authority) for verification'
  end

  newproperty(:url) do
    desc 'The url of the smart proxy'
    isrequired
    newvalues(URI.regexp)
  end

  newproperty(:organizations, :array_matching => :all) do
    desc 'Names of the organizations to add to the smart proxy'
  end

  newproperty(:locations, :array_matching => :all) do
    desc 'Names of the locations to add to the smart proxy'
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
