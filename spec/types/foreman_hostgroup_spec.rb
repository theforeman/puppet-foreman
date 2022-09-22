require 'spec_helper'

describe 'foreman_hostgroup' do
  let :title do
    'example_hostgroup'
  end

  it { is_expected.to be_valid_type }
  it { is_expected.to be_valid_type.with_provider(:rest_v3) }

  it {
    expect(subject).to be_valid_type.with_properties(
      %i[
        ensure
        description
        locations
        organizations
      ]
    )
  }

  it {
    expect(subject).to be_valid_type.with_parameters(
      %i[
        parent_hostgroup
        parent_hostgroup_name
        base_url
        effective_user
        consumer_key
        consumer_secret
        ssl_ca
        timeout
      ]
    )
  }
end
