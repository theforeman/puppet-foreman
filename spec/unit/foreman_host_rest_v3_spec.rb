require 'spec_helper'

describe Puppet::Type.type(:foreman_host).provider(:rest_v3) do
  let(:resource) do
    Puppet::Type.type(:foreman_host).new(
      :name => 'foreman-proxy.example.com',
      :hostname => 'proxy.example.com',
      :facts => { 'foo' => 'bar' },
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
      expect(provider).to receive(:request).with(:post, 'api/v2/hosts/facts', {}, kind_of(String)).and_return(
        double(:code => '201', :body => {'id' => 1, 'name' => 'proxy.example.com'})
      )
      provider.create
    end
  end

  describe '#destroy' do
    it 'sends DELETE request' do
      expect(provider).to receive(:id).and_return(1)
      expect(provider).to receive(:request).with(:delete, 'api/v2/hosts/1', {}).and_return(double(:code => '204'))
      provider.destroy
    end
  end

  describe '#exists?' do
    it 'returns true when host is marked as a foreman host' do
      expect(provider).to receive(:host).twice.and_return({"id" => 1})
      expect(provider.exists?).to be true
    end

    it 'returns nil when host does not exist' do
      expect(provider).to receive(:host).and_return(nil)
      expect(provider.exists?).to be false
    end
  end

  describe '#id' do
    it 'returns ID from host hash' do
      expect(provider).to receive(:host).twice.and_return({'id' => 1})
      expect(provider.id).to eq(1)
    end

    it 'returns nil when host is absent' do
      expect(provider).to receive(:host).and_return(nil)
      expect(provider.id).to be_nil
    end
  end

  describe '#host' do
    it 'returns host hash from API results' do
      expect(provider).to receive(:request).with(:get, 'api/v2/hosts', :search => 'name="proxy.example.com"').and_return(
        double('response', :body => {:results => [{:id => 1, :name => 'proxy.example.com'}]}.to_json, :code => '200')
      )
      expect(provider.host['id']).to eq(1)
      expect(provider.host['name']).to eq('proxy.example.com')
    end
  end
end
