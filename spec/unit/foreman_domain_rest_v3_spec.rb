require 'spec_helper'

describe Puppet::Type.type(:foreman_domain).provider(:rest_v3) do
  let(:resource) do
    Puppet::Type.type(:foreman_domain).new(
      :name => 'example.com',
      :fullname => 'domain entry for example.com',
      :base_url => 'https://foreman.example.com',
      :consumer_key => 'oauth_key',
      :consumer_secret => 'oauth_secret',
      :effective_user => 'admin'
    )
  end

  let(:provider) do
    provider = described_class.new
    provider.resource = resource
    provider
  end

  describe '#create' do
    it 'sends POST request' do
      expect(provider).to receive(:request).with(:post, 'api/v2/domains', {}, kind_of(String)).and_return(
        double(:code => '201', :body => {'id' => 1, 'name' => 'example.com', 'fullname' => 'domain entry for example.com'})
      )
      provider.create
    end
  end

  describe '#destroy' do
    it 'sends DELETE request' do
      expect(provider).to receive(:id).and_return(1)
      expect(provider).to receive(:request).with(:delete, 'api/v2/domains/1', {}).and_return(double(:code => '204'))
      provider.destroy
    end
  end

  describe '#exists?' do
    it 'returns true when domain is marked as a foreman domain' do
      expect(provider).to receive(:domain).twice.and_return({"id" => 1})
      expect(provider.exists?).to be true
    end

    it 'returns nil when domain does not exist' do
      expect(provider).to receive(:domain).and_return(nil)
      expect(provider.exists?).to be false
    end
  end

  describe '#id' do
    it 'returns ID from domain hash' do
      expect(provider).to receive(:domain).twice.and_return({'id' => 1})
      expect(provider.id).to eq(1)
    end

    it 'returns nil when domain is absent' do
      expect(provider).to receive(:domain).and_return(nil)
      expect(provider.id).to be_nil
    end
  end

  describe '#domain' do
    it 'returns domain hash from API results' do
      expect(provider).to receive(:request).with(:get, 'api/v2/domains', :search => 'name="example.com"').and_return(
        double('response', :body => {:results => [{:id => 1, :name => 'example.com'}]}.to_json, :code => '200')
      )
      expect(provider.domain['id']).to eq(1)
      expect(provider.domain['name']).to eq('example.com')
    end
  end
end
