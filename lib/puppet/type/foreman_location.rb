# frozen_string_literal: true

require 'puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_location) do
  desc 'foreman_location configures a location in foreman.'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)

  newparam(:name) do
    desc 'The name of the location'
  end

  newproperty(:parent) do
    desc 'The name of the parent location'
  end

  newproperty(:description) do
    desc 'The description of this location'
  end

  newproperty(:select_all_types, array_matching: :all) do
    desc 'List of resource types for which to "Select All"'
  end

  newproperty(:domains, array_matching: :all) do
    desc 'A list of domain names to allow for this location'
  end

  newproperty(:organizations, array_matching: :all) do
    desc 'A list of organization names to allow for this location'
  end

  autorequire(:foreman_location) do
    self[:parent] if self[:ensure] == :present
  end
end
