# frozen_string_literal: true

require 'puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_organization) do
  desc 'foreman_organization configures a organization in foreman.'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)

  newparam(:name) do
    desc 'The name of the organization'
  end

  newproperty(:parent) do
    desc 'The name of the parent organization'
  end

  newproperty(:description) do
    desc 'The description of this organization'
  end

  newproperty(:select_all_types, array_matching: :all) do
    desc 'List of resource types for which to "Select All"'
  end

  newproperty(:domains, array_matching: :all) do
    desc 'A list of domain names to allow for this organization'
  end

  newproperty(:locations, array_matching: :all) do
    desc 'A list of location names to allow for this organization'
  end

  autorequire(:foreman_organization) do
    self[:parent] if self[:ensure] == :present
  end
end
