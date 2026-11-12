require 'spec_helper'

describe Puppet::Type.type(:foreman_subnet).provider(:rest_v3) do
  let(:resource) do
    Puppet::Type.type(:foreman_subnet).new(
      :name => '192.168.1.0',
      :network_type => 'IPv4',
      :network => '192.168.1.0',
      :cidr => 24,
      :mask => '255.255.255.0',
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
    it 'sends POST request with defaults' do
      expect(provider).to receive(:request).with(:post, 'api/v2/subnets', {}, kind_of(String)) do |_, _, _, body|
        subnet = JSON.parse(body)['subnet']
        expect(subnet['name']).to eq('192.168.1.0')
        expect(subnet['ipam']).to eq('None')
        expect(subnet['domain_ids']).to eq([])
        double(:code => '201')
      end
      provider.create
    end

    it 'resolves search= references to IDs' do
      resource[:domain_ids] = ['search=name=example.com', 7]
      resource[:dhcp_id] = 'search=name=proxy.example.com'
      expect(provider).to receive(:lookup_id).with('domains', 'search=name=example.com').and_return(3)
      expect(provider).to receive(:lookup_id).with('domains', 7).and_return(7)
      expect(provider).to receive(:lookup_id).with('smart_proxies', 'search=name=proxy.example.com').and_return(5)
      allow(provider).to receive(:lookup_id).with('smart_proxies', nil).and_return(nil)
      expect(provider).to receive(:request).with(:post, 'api/v2/subnets', {}, kind_of(String)) do |_, _, _, body|
        subnet = JSON.parse(body)['subnet']
        expect(subnet['domain_ids']).to eq([3, 7])
        expect(subnet['dhcp_id']).to eq(5)
        double(:code => '201')
      end
      provider.create
    end

    it 'raises when the API returns an error' do
      expect(provider).to receive(:request).and_return(double(:code => '422', :message => 'Unprocessable', :body => 'nope'))
      expect(provider).to receive(:request_uri).and_return('https://foreman.example.com/api/v2/subnets')
      allow(provider).to receive(:error_message).and_return('boom')
      expect { provider.create }.to raise_error(Puppet::Error, /POST request/)
    end
  end

  describe '#destroy' do
    it 'sends DELETE request' do
      expect(provider).to receive(:id).and_return(1)
      expect(provider).to receive(:request).with(:delete, 'api/v2/subnets/1', {}).and_return(double(:code => '204'))
      provider.destroy
    end

    it 'raises a Puppet::Error when the API returns an error' do
      allow(provider).to receive(:id).and_return(1)
      expect(provider).to receive(:request).and_return(double(:code => '500', :message => 'Server Error', :body => 'nope'))
      expect(provider).to receive(:request_uri).with('api/v2/subnets/1').and_return('https://foreman.example.com/api/v2/subnets/1')
      allow(provider).to receive(:error_message).and_return('boom')
      expect { provider.destroy }.to raise_error(Puppet::Error, /DELETE request/)
    end
  end

  describe '#exists?' do
    it 'returns true when the subnet exists' do
      allow(provider).to receive(:subnet).and_return('id' => 1)
      expect(provider.exists?).to be true
    end

    it 'returns false when the subnet does not exist' do
      allow(provider).to receive(:subnet).and_return(nil)
      expect(provider.exists?).to be false
    end
  end

  describe '#subnet' do
    it 'returns subnet hash from API results' do
      expect(provider).to receive(:request).with(:get, 'api/v2/subnets', :search => 'name="192.168.1.0"').and_return(
        double('response', :body => {:results => [{:id => 1, :name => '192.168.1.0'}]}.to_json, :code => '200')
      )
      expect(provider.subnet['id']).to eq(1)
    end
  end
end
