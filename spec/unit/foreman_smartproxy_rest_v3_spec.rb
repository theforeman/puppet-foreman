require 'spec_helper'

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
    it 'sends POST request' do
      expect(provider).to receive(:request).with(:post, 'api/v2/smart_proxies', {}, kind_of(String)).and_return(
        double(:code => '201', :body => {'features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}]}.to_json)
      )
      provider.create
    end

    it 'raises error if features do not match' do
      expect(provider).to receive(:request).with(:post, 'api/v2/smart_proxies', {}, kind_of(String)).and_return(
        double(:code => '201', :body => {'features' => [{'name' => 'TFTP'}]}.to_json)
      )
      expect { provider.create }.to raise_error(Puppet::Error, /Proxy proxy.example.com has failed to load one or more features \(Logs\)/)
    end

    it 'does not raise an error if a superset of expected features are enabled' do
      expect(provider).to receive(:request).with(:post, 'api/v2/smart_proxies', {}, kind_of(String)).and_return(
        double(:code => '201', :body => {'features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}, {'name' => 'Other'}]}.to_json)
      )
      provider.create
    end
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
      it 'sends PUT request to /refresh, raises no error' do
        expect(provider).to receive(:id).and_return(1)
        expect(provider).to receive(:request).with(:put, 'api/v2/smart_proxies/1/refresh').and_return(
          double(:code => '200', :body => {'features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}]}.to_json)
        )
        provider.refresh_features!
      end

      it 'raises error if features do not match' do
        expect(provider).to receive(:id).and_return(1)
        expect(provider).to receive(:request).with(:put, 'api/v2/smart_proxies/1/refresh').and_return(
          double(:code => '200', :body => {'features' => [{'name' => 'TFTP'}]}.to_json)
        )
        expect { provider.refresh_features! }.to raise_error(Puppet::Error, /Proxy proxy.example.com has failed to load one or more features \(Logs\)/)
      end

      it 'does not raise an error if a superset of expected features are enabled' do
        expect(provider).to receive(:id).and_return(1)
        expect(provider).to receive(:request).with(:put, 'api/v2/smart_proxies/1/refresh').and_return(
          double(:code => '200', :body => {'features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}, {'name' => 'Other'}]}.to_json)
        )
        provider.refresh_features!
      end
    end

    context 'without features in refresh response re-fetches proxy' do
      it 'sends PUT request to /refresh, raises no error' do
        expect(provider).to receive(:id).and_return(1)
        expect(provider).to receive(:request).with(:put, 'api/v2/smart_proxies/1/refresh').and_return(
          double(:code => '200', :body => {}.to_json)
        )
        expect(provider).to receive(:request).with(:get, 'api/v2/smart_proxies', :search => 'name="proxy.example.com"').and_return(
          double('response', :body => {:results => [{:id => 1, :name => 'proxy.example.com', 'features' => [{'name' => 'TFTP'}, {'name' => 'Logs'}]}]}.to_json, :code => '200')
        )
        provider.refresh_features!
      end

      it 'raises error if features do not match' do
        expect(provider).to receive(:id).and_return(1)
        expect(provider).to receive(:request).with(:put, 'api/v2/smart_proxies/1/refresh').and_return(
          double(:code => '200', :body => {}.to_json)
        )
        expect(provider).to receive(:request).with(:get, 'api/v2/smart_proxies', :search => 'name="proxy.example.com"').and_return(
          double('response', :body => {:results => [{:id => 1, :name => 'proxy.example.com', 'features' => [{'name' => 'TFTP'}]}]}.to_json, :code => '200')
        )
        expect { provider.refresh_features! }.to raise_error(Puppet::Error, /Proxy proxy.example.com has failed to load one or more features \(Logs\)/)
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
