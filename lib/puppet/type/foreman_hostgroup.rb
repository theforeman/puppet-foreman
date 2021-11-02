# frozen_string_literal: true

require_relative '../../puppet_x/foreman/common'
Puppet::Type.newtype(:foreman_hostgroup) do
  desc 'foreman_hostgroup manages hostgroups in foreman.'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)

  def self.title_patterns
    [
      [
        %r{^(.+)/(.+)$},
        [
          [:parent_hostgroup],
          [:name]
        ]
      ],
      [
        %r{(.+)},
        [
          [:name]
        ]
      ]
    ]
  end
  newparam(:name, namevar: true) do
    desc 'The name of the hostgroup.'
  end

  newparam(:parent_hostgroup, namevar: true) do
    desc 'The full title of the parent hostgroup'
  end

  newparam(:parent_hostgroup_name) do
    desc 'The name of the parent hostgroup.  This only needs to be given if your hostgroups contain slashes!'
  end

  newproperty(:description) do
    desc 'The hostgroup\'s `description`'
  end

  newproperty(:organizations, array_matching: :all) do
    desc 'An array of organizations (full titles) that this hostgroup should be part of'
    def insync?(is) # rubocop:disable Naming/MethodParameterName
      is.sort == should.sort
    end
  end

  newproperty(:locations, array_matching: :all) do
    desc 'An array of locations (full titles) that this hostgroup should be part of'
    def insync?(is) # rubocop:disable Naming/MethodParameterName
      is.sort == should.sort
    end
  end

  autorequire(:foreman_hostgroup) do
    self[:parent_hostgroup] if self[:ensure] == :present
  end
end
