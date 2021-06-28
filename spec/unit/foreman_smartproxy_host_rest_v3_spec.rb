require 'spec_helper'

describe Puppet::Type.type(:foreman_smartproxy_host).provider(:rest_v3) do
  let(:resource) do
    Puppet::Type.type(:foreman_smartproxy_host).new(
      :name => 'proxy.example.com',
      :hostname => 'proxy.example.com',
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
      expect(provider).to receive(:host).thrice.and_return({"id" => 1})
      expect(provider).to receive(:proxy).thrice.and_return({"id" => 2})
      expect(provider).to receive(:request).with(:put, 'api/v2/smart_proxies/2/hosts/1', {}).and_return(
        double(:code => '201', :body => '')
      )
      provider.create
    end

    it 'raises an exception if the host does not exist' do
      expect(provider).to receive(:host).and_return(nil)
      expect { provider.create }.to raise_error(Puppet::Error, /Host proxy.example.com does not exist in Foreman/)
    end

    it 'raises an exception if the proxy does not exist' do
      expect(provider).to receive(:host).and_return({"id" => 1})
      expect(provider).to receive(:proxy).and_return(nil)
      expect { provider.create }.to raise_error(Puppet::Error, /Proxy proxy.example.com does not exist in Foreman/)
    end
  end

  describe '#destroy' do
    it 'sends DELETE request' do
      expect(provider).to receive(:host_id).and_return(1)
      expect(provider).to receive(:proxy_id).and_return(2)
      expect(provider).to receive(:request).with(:delete, 'api/v2/smart_proxies/2/hosts/1', {}).and_return(double(:code => '204'))
      provider.destroy
    end
  end

  describe '#exists?' do
    it 'returns true when host is marked as current proxy' do
      expect(provider).to receive(:proxy).thrice.and_return({"id" => 1})
      expect(provider).to receive(:host).twice.and_return({"smart_proxy_id" => 1})
      expect(provider.exists?).to be true
    end

    it 'returns false when host is marked as a different smart proxy' do
      expect(provider).to receive(:proxy).thrice.and_return({"id" => 1})
      expect(provider).to receive(:host).twice.and_return({"smart_proxy_id" => 2})
      expect(provider.exists?).to be false
    end

    it 'returns false when host is not marked as a smart proxy' do
      expect(provider).to receive(:proxy).thrice.and_return({"id" => 1})
      expect(provider).to receive(:host).twice.and_return({"smart_proxy_id" => nil})
      expect(provider.exists?).to be false
    end

    it 'returns false when host does not exist' do
      expect(provider).to receive(:host).and_return(nil)
      expect(provider.exists?).to be false
    end

    it 'returns false when smart proxy does not exist' do
      expect(provider).to receive(:host).and_return({"smart_proxy_id" => 1})
      expect(provider).to receive(:proxy).and_return(nil)
      expect(provider.exists?).to be false
    end
  end

  describe '#proxy_id' do
    it 'returns ID from host hash' do
      expect(provider).to receive(:proxy).twice.and_return({'id' => 1})
      expect(provider.proxy_id).to eq(1)
    end

    it 'returns nil when host is absent' do
      expect(provider).to receive(:proxy).and_return(nil)
      expect(provider.proxy_id).to be_nil
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

  describe '#proxy' do
    it 'returns proxy hash from API results' do
      expect(provider).to receive(:request).with(:get, 'api/v2/smart_proxies', :search => 'name="proxy.example.com"').and_return(
        double('response', :body => {:results => [{:id => 1, :name => 'proxy.example.com'}]}.to_json, :code => '200')
      )
      expect(provider.proxy['id']).to eq(1)
      expect(provider.proxy['name']).to eq('proxy.example.com')
    end
  end
end
