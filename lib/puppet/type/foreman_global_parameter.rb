# frozen_string_literal: true

require_relative '../../puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_global_parameter) do
  desc 'foreman_global_parameter Manipulate global parameters'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)

  newparam(:name, namevar: true) do
    desc 'Parameter name'
  end

  newproperty(:parameter_type) do
    desc 'Type of the parameter'

    munge { |v| v.to_s }
  end

  newproperty(:value) do
    desc 'Parameter value'

    munge { |v| @resource.munge_boolean_to_symbol(v) }
  end

  newproperty(:hidden_value) do
    desc 'Should the value be hidden'

    munge { |v| @resource.munge_boolean_to_symbol(v) }

    validate do |v|
      unless [TrueClass, FalseClass].include?(v.class)
        raise Puppet::ResourceError, 'hidden_value expected a boolean value.'
      end
    end
  end

  # Convert booleans into symbols to work around parameter/property handling of
  # booleans being broken.
  #
  # See:
  # https://tickets.puppetlabs.com/browse/PUP-2368
  # https://tickets.puppetlabs.com/browse/PUP-8442
  def munge_boolean_to_symbol(value)
    case value
    when TrueClass
      :true
    when FalseClass
      :false
    else
      value
    end
  end

  def munge_symbol_to_boolean(value)
    case value
    when :true
      true
    when :false
      false
    else
      value
    end
  end
end
