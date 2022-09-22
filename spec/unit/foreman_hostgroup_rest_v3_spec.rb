# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:foreman_hostgroup).provider(:rest_v3) do
  let(:basic_params) do
    {
      name: 'example_hostgroup',
      base_url: 'https://foreman.example.com',
      consumer_key: 'oauth_key',
      consumer_secret: 'oauth_secret',
      effective_user: 'admin'
    }
  end

  let(:resource) do
    Puppet::Type.type(:foreman_hostgroup).new(
      basic_params
    )
  end

  let(:provider) do
    provider = described_class.new
    provider.resource = resource
    provider
  end

  describe '#create' do
    let(:expected_post_data) do
      {
        'hostgroup' => {
          'name' => 'example_hostgroup',
          'parent_id' => nil,
          'description' => nil,
          'organization_ids' => nil,
          'location_ids' => nil,
        }
      }.to_json
    end

    it 'sends POST request' do
      allow(provider).to receive(:request).with(:post, 'api/v2/hostgroups', {}, expected_post_data).and_return(
        instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
      )
      provider.create
    end

    context 'with description set' do
      let(:resource) do
        Puppet::Type.type(:foreman_hostgroup).new(
          basic_params.merge(description: 'example description')
        )
      end
      let(:expected_post_data) do
        {
          'hostgroup' => {
            'name' => 'example_hostgroup',
            'parent_id' => nil,
            'description' => 'example description',
            'organization_ids' => nil,
            'location_ids' => nil,
          }
        }.to_json
      end

      it 'sends POST request' do
        allow(provider).to receive(:request).with(:post, 'api/v2/hostgroups', {}, expected_post_data).and_return(
          instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
        )
        provider.create
      end
    end

    context 'with organizations set' do
      let(:resource) do
        Puppet::Type.type(:foreman_hostgroup).new(
          basic_params.merge(organizations: %w[org1 org2])
        )
      end
      let(:expected_post_data) do
        {
          'hostgroup' => {
            'name' => 'example_hostgroup',
            'parent_id' => nil,
            'description' => nil,
            'organization_ids' => [101, 102],
            'location_ids' => nil,
          }
        }.to_json
      end

      it do
        allow(provider).to receive(:organization_id).with('org1').and_return(101)
        allow(provider).to receive(:organization_id).with('org2').and_return(102)
        allow(provider).to receive(:request).with(:post, 'api/v2/hostgroups', {}, expected_post_data).and_return(
          instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
        )
        provider.create
      end
    end

    context 'with locations set' do
      let(:resource) do
        Puppet::Type.type(:foreman_hostgroup).new(
          basic_params.merge(locations: %w[loc1 loc2])
        )
      end
      let(:expected_post_data) do
        {
          'hostgroup' => {
            'name' => 'example_hostgroup',
            'parent_id' => nil,
            'description' => nil,
            'organization_ids' => nil,
            'location_ids' => [201, 202],
          }
        }.to_json
      end

      it do
        allow(provider).to receive(:location_id).with('loc1').and_return(201)
        allow(provider).to receive(:location_id).with('loc2').and_return(202)
        allow(provider).to receive(:request).with(:post, 'api/v2/hostgroups', {}, expected_post_data).and_return(
          instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
        )
        provider.create
      end
    end
  end

  describe '#destroy' do
    it 'sends DELETE request' do
      allow(provider).to receive(:id).and_return(42)
      allow(provider).to receive(:request).with(:delete, 'api/v2/hostgroups/42').and_return(
        instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
      )
      provider.destroy
    end
  end
end
