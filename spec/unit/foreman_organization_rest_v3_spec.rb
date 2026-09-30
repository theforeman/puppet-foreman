# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:foreman_organization).provider(:rest_v3) do # rubocop:disable Metrics/BlockLength
  let(:basic_params) do
    {
      name: 'example_organization',
      base_url: 'https://foreman.example.com',
      consumer_key: 'oauth_key',
      consumer_secret: 'oauth_secret',
      effective_user: 'admin'
    }
  end

  let(:resource) do
    Puppet::Type.type(:foreman_organization).new(
      basic_params
    )
  end

  let(:provider) do
    provider = described_class.new
    provider.resource = resource
    provider
  end

  describe '#create' do # rubocop:disable Metrics/BlockLength
    let(:expected_post_data) do
      {
        'organization' => {
          'name' => 'example_organization',
          'parent_id' => nil,
          'description' => nil,
          'ignore_types' => nil,
          'domain_ids' => nil,
          'location_ids' => nil
        }
      }.to_json
    end

    it 'sends POST request' do
      allow(provider).to receive(:request).with(:post, 'api/v2/organizations', {}, expected_post_data).and_return(
        instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
      )
      provider.create
    end

    context 'with parent set' do
      let(:resource) do
        Puppet::Type.type(:foreman_organization).new(
          basic_params.merge(parent: 'parent_organization')
        )
      end
      let(:expected_post_data) do
        {
          'organization' => {
            'name' => 'example_organization',
            'parent_id' => 101,
            'description' => nil,
            'ignore_types' => nil,
            'domain_ids' => nil,
            'location_ids' => nil
          }
        }.to_json
      end

      it 'sends POST request' do
        allow(provider).to receive(:organization_id).with('parent_organization').and_return(101)
        allow(provider).to receive(:request).with(:post, 'api/v2/organizations', {}, expected_post_data).and_return(
          instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
        )
        provider.create
      end
    end

    context 'with description set' do
      let(:resource) do
        Puppet::Type.type(:foreman_organization).new(
          basic_params.merge(description: 'example description')
        )
      end
      let(:expected_post_data) do
        {
          'organization' => {
            'name' => 'example_organization',
            'parent_id' => nil,
            'description' => 'example description',
            'ignore_types' => nil,
            'domain_ids' => nil,
            'location_ids' => nil
          }
        }.to_json
      end

      it 'sends POST request' do
        allow(provider).to receive(:request).with(:post, 'api/v2/organizations', {}, expected_post_data).and_return(
          instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
        )
        provider.create
      end
    end

    context 'with select_all_types set' do
      let(:resource) do
        Puppet::Type.type(:foreman_organization).new(
          basic_params.merge(select_all_types: %w[SmartProxies])
        )
      end
      let(:expected_post_data) do
        {
          'organization' => {
            'name' => 'example_organization',
            'parent_id' => nil,
            'description' => nil,
            'ignore_types' => %w[SmartProxies],
            'domain_ids' => nil,
            'location_ids' => nil
          }
        }.to_json
      end

      it 'sends POST request' do
        allow(provider).to receive(:request).with(:post, 'api/v2/organizations', {}, expected_post_data).and_return(
          instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
        )
        provider.create
      end
    end

    context 'with domains set' do
      let(:resource) do
        Puppet::Type.type(:foreman_organization).new(
          basic_params.merge(domains: ['example.com', 'example.org'])
        )
      end
      let(:expected_post_data) do
        {
          'organization' => {
            'name' => 'example_organization',
            'parent_id' => nil,
            'description' => nil,
            'ignore_types' => nil,
            'domain_ids' => [301, 302],
            'location_ids' => nil
          }
        }.to_json
      end

      it 'sends POST request' do
        allow(provider).to receive(:domain_ids).with(['example.com', 'example.org']).and_return([301, 302])
        allow(provider).to receive(:request).with(:post, 'api/v2/organizations', {}, expected_post_data).and_return(
          instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
        )
        provider.create
      end
    end

    context 'with locations set' do
      let(:resource) do
        Puppet::Type.type(:foreman_organization).new(
          basic_params.merge(locations: %w[loc1 loc2])
        )
      end
      let(:expected_post_data) do
        {
          'organization' => {
            'name' => 'example_organization',
            'parent_id' => nil,
            'description' => nil,
            'ignore_types' => nil,
            'domain_ids' => nil,
            'location_ids' => [201, 202]
          }
        }.to_json
      end

      it 'sends POST request' do
        allow(provider).to receive(:location_id).with('loc1').and_return(201)
        allow(provider).to receive(:location_id).with('loc2').and_return(202)
        allow(provider).to receive(:request).with(:post, 'api/v2/organizations', {}, expected_post_data).and_return(
          instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
        )
        provider.create
      end
    end
  end

  describe '#destroy' do
    it 'sends DELETE request' do
      allow(provider).to receive(:id).and_return(42)
      allow(provider).to receive(:request).with(:delete, 'api/v2/organizations/42').and_return(
        instance_double(Net::HTTPOK, code: '201', body: {}.to_json)
      )
      provider.destroy
    end
  end
end
