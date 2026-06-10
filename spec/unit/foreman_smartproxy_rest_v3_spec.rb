require 'spec_helper'

shared_examples 'unrecognized features handling' do
  it 'warns about unrecognized features' do
    stub_proxy_response('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}], 'unrecognized_features' => ['NewFeature'])
    expect(Puppet).to receive(:warning).with(/Proxy proxy.example.com has features not recognized by Foreman: NewFeature/)
    trigger
  end

  it 'does not warn when unrecognized features list is empty' do
    stub_proxy_response('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}], 'unrecognized_features' => [])
    expect(Puppet).not_to receive(:warning)
    trigger
  end

  it 'does not warn when unrecognized_features key is absent' do
    stub_proxy_response('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}])
    expect(Puppet).not_to receive(:warning)
    trigger
  end

  it 'does not crash when unrecognized_features is nil' do
    stub_proxy_response('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}], 'unrecognized_features' => nil)
    expect(Puppet).not_to receive(:warning)
    expect { trigger }.not_to raise_error
  end

  it 'warns about multiple unrecognized features' do
    stub_proxy_response('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}], 'unrecognized_features' => ['FeatureA', 'FeatureB'])
    expect(Puppet).to receive(:warning).with(/FeatureA, FeatureB/)
    trigger
  end

  it 'warns about unrecognized features and still raises on missing expected features' do
    stub_proxy_response('features' => [{'name' => 'TFTP'}], 'unrecognized_features' => ['NewFeature'])
    expect(Puppet).to receive(:warning).with(/NewFeature/)
    expect { trigger }.to raise_error(Puppet::Error, /failed to load one or more features \(Logs\)/)
  end
end

describe Puppet::Type.type(:foreman_smartproxy).provider(:rest_v3) do
  let(:resource) do
    Puppet::Type.type(:foreman_smartproxy).new(
      :name => 'proxy.example.com',
      :url => 'https://proxy.example.com:8443',
      :base_url => 'https://foreman.example.com',
      :consumer_key => 'oauth_key',
      :consumer_secret => 'oauth_secret',
      :effective_user => 'admin',
      :features => ['TFTP', 'Logs'],
    )
  end

  let(:provider) do
    provider = described_class.new
    provider.resource = resource
    provider
  end

  describe '#create' do
    def stub_proxy_response(body)
      expect(provider).to receive(:request).with(:post, 'api/v2/smart_proxies', {}, kind_of(String)).and_return(
        double(:code => '201', :body => body.to_json)
      )
    end

    def trigger
      provider.create
    end

    it 'sends POST request' do
      stub_proxy_response('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}])
      provider.create
    end

    it 'raises error if features do not match' do
      stub_proxy_response('features' => [{'name' => 'TFTP'}])
      expect { provider.create }.to raise_error(Puppet::Error, /Proxy proxy.example.com has failed to load one or more features \(Logs\)/)
    end

    it 'does not raise an error if a superset of expected features are enabled' do
      stub_proxy_response('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}, {'name' => 'Other'}])
      provider.create
    end

    it_behaves_like 'unrecognized features handling'
  end

  describe '#destroy' do
    it 'sends DELETE request' do
      expect(provider).to receive(:id).and_return(1)
      expect(provider).to receive(:request).with(:delete, 'api/v2/smart_proxies/1').and_return(double(:code => '200'))
      provider.destroy
    end
  end

  describe '#exists?' do
    it 'returns true when ID is present' do
      expect(provider).to receive(:id).and_return(1)
      expect(provider.exists?).to be true
    end

    it 'returns nil when ID is absent' do
      expect(provider).to receive(:id).and_return(nil)
      expect(provider.exists?).to be false
    end
  end

  describe '#features' do
    it 'returns feature names from proxy hash' do
      expect(provider).to receive(:proxy).twice.and_return('id' => 1, 'name' => 'proxy.example.com', 'features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}])
      expect(provider.features).to eq(['Logs', 'TFTP'])
    end

    it 'returns empty array when proxy is absent' do
      expect(provider).to receive(:proxy).and_return(nil)
      expect(provider.features).to eq([])
    end
  end

  describe '#features=' do
    it 'refreshes features' do
      expect(provider).to receive(:refresh_features!)
      provider.features = ['TFTP', 'Logs']
    end
  end

  describe '#id' do
    it 'returns ID from proxy hash' do
      expect(provider).to receive(:proxy).twice.and_return({'id' => 1, 'name' => 'proxy.example.com'})
      expect(provider.id).to eq(1)
    end

    it 'returns nil when proxy is absent' do
      expect(provider).to receive(:proxy).and_return(nil)
      expect(provider.id).to be_nil
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

  describe '#refresh_features!' do
    context 'with features in response' do
      def stub_proxy_response(body)
        expect(provider).to receive(:id).and_return(1)
        expect(provider).to receive(:request).with(:put, 'api/v2/smart_proxies/1/refresh').and_return(
          double(:code => '200', :body => body.to_json)
        )
      end

      def trigger
        provider.refresh_features!
      end

      it 'sends PUT request to /refresh, raises no error' do
        stub_proxy_response('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}])
        provider.refresh_features!
      end

      it 'raises error if features do not match' do
        stub_proxy_response('features' => [{'name' => 'TFTP'}])
        expect { provider.refresh_features! }.to raise_error(Puppet::Error, /Proxy proxy.example.com has failed to load one or more features \(Logs\)/)
      end

      it 'does not raise an error if a superset of expected features are enabled' do
        stub_proxy_response('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}, {'name' => 'Other'}])
        provider.refresh_features!
      end

      it_behaves_like 'unrecognized features handling'
    end

    context 'without features in refresh response re-fetches proxy' do
      def stub_refresh_and_refetch(refetched_proxy)
        expect(provider).to receive(:id).and_return(1)
        expect(provider).to receive(:request).with(:put, 'api/v2/smart_proxies/1/refresh').and_return(
          double(:code => '200', :body => {}.to_json)
        )
        expect(provider).to receive(:request).with(:get, 'api/v2/smart_proxies', :search => 'name="proxy.example.com"').and_return(
          double('response', :body => {:results => [{:id => 1, :name => 'proxy.example.com'}.merge(refetched_proxy)]}.to_json, :code => '200')
        )
      end

      it 'sends PUT request to /refresh, raises no error' do
        stub_refresh_and_refetch('features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}])
        provider.refresh_features!
      end

      it 'raises error if features do not match' do
        stub_refresh_and_refetch('features' => [{'name' => 'TFTP'}])
        expect { provider.refresh_features! }.to raise_error(Puppet::Error, /Proxy proxy.example.com has failed to load one or more features \(Logs\)/)
      end

      it 'warns about unrecognized features after re-fetch and still validates' do
        stub_refresh_and_refetch('features' => [{'name' => 'TFTP'}], 'unrecognized_features' => ['NewFeature'])
        expect(Puppet).to receive(:warning).with(/NewFeature/)
        expect { provider.refresh_features! }.to raise_error(Puppet::Error, /failed to load one or more features \(Logs\)/)
      end
    end
  end

  describe '#url' do
    it 'returns ID from proxy hash' do
      expect(provider).to receive(:proxy).twice.and_return({'id' => 1, 'url' => 'https://proxy.example.com:8443'})
      expect(provider.url).to eq('https://proxy.example.com:8443')
    end

    it 'returns nil when proxy is absent' do
      expect(provider).to receive(:proxy).and_return(nil)
      expect(provider.url).to be_nil
    end
  end

  describe '#url=' do
    it 'sends PUT request' do
      expect(provider).to receive(:id).and_return(1)
      expect(provider).to receive(:request).with(:put, 'api/v2/smart_proxies/1', {}, %r{"url":"https://new.example.com:8443"}).and_return(double(:code => '200'))
      provider.url = 'https://new.example.com:8443'
    end
  end
end
