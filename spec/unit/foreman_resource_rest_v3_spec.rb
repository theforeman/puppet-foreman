require 'spec_helper'
require 'oauth'

provider_class = Puppet::Type.type(:foreman_resource).provider(:rest_v3)
describe provider_class do
  let(:resource) do
    double('resource')
  end

  let(:provider) do
    provider = provider_class.new
    provider.resource = resource
    provider
  end

  describe '#generate_token' do
    it 'returns an OAuth::AccessToken' do
      expect(provider).to receive(:oauth_consumer).and_return(OAuth::Consumer.new('test', 'test'))
      expect(provider.generate_token).to be_an(OAuth::AccessToken)
    end
  end

  describe '#oauth_consumer' do
    it 'returns an OAuth::Consumer' do
      expect(provider).to receive(:oauth_consumer_key).and_return('oauth_key')
      expect(provider).to receive(:oauth_consumer_secret).and_return('oauth_secret')
      expect(resource).to receive(:[]).with(:base_url).and_return('https://foreman.example.com')
      expect(resource).to receive(:[]).with(:ssl_ca).and_return('/etc/foreman/ssl/ca.pem')
      expect(resource).to receive(:[]).with(:timeout).and_return(500)
      consumer = provider.oauth_consumer
      expect(consumer).to be_an(OAuth::Consumer)
      expect(consumer.site).to eq('https://foreman.example.com')
      expect(consumer.options[:ca_file]).to eq('/etc/foreman/ssl/ca.pem')
      expect(consumer.options[:timeout]).to eq(500)
    end
  end

  describe '#oauth_consumer_key' do
    it 'uses resource consumer_key' do
      expect(resource).to receive(:[]).twice.with(:consumer_key).and_return('oauth_key')
      expect(provider.oauth_consumer_key).to eq('oauth_key')
    end

    it 'uses settings.yaml if resource has no consumer_key' do
      expect(resource).to receive(:[]).with(:consumer_key).and_return(nil)
      expect(YAML).to receive(:load_file).with('/etc/foreman/settings.yaml').and_return(:oauth_consumer_key => 'oauth_key')
      expect(provider.oauth_consumer_key).to eq('oauth_key')
    end
  end

  describe '#oauth_consumer_secret' do
    it 'uses resource consumer_secret' do
      expect(resource).to receive(:[]).twice.with(:consumer_secret).and_return('oauth_secret')
      expect(provider.oauth_consumer_secret).to eq('oauth_secret')
    end

    it 'uses settings.yaml if resource has no consumer_secret' do
      expect(resource).to receive(:[]).with(:consumer_secret).and_return(nil)
      expect(YAML).to receive(:load_file).with('/etc/foreman/settings.yaml').and_return(:oauth_consumer_secret => 'oauth_secret')
      expect(provider.oauth_consumer_secret).to eq('oauth_secret')
    end
  end

  describe '#request' do
    before do
      expect(resource).to receive(:[]).with(:base_url).and_return(base_url)
      expect(resource).to receive(:[]).with(:effective_user).and_return(effective_user)
      expect(provider).to receive(:oauth_consumer).at_least(1).and_return(consumer)
    end

    let(:base_url) { 'https://foreman.example.com' }
    let(:consumer) { double('oauth_consumer') }
    let(:effective_user) { 'admin' }

    it 'makes GET request via consumer and returns response' do
      response = double(:code => '200')
      expect(consumer).to receive(:request).with(:get, 'https://foreman.example.com/api/v2/example', kind_of(OAuth::AccessToken), {}, kind_of(Hash)).and_return(response)
      expect(provider.request(:get, 'api/v2/example')).to eq(response)
    end

    it 'makes PUT request via consumer and returns response' do
      response = double(:code => '200')
      expect(consumer).to receive(:request).with(:put, 'https://foreman.example.com/api/v2/example', kind_of(OAuth::AccessToken), {}, nil, kind_of(Hash)).and_return(response)
      expect(provider.request(:put, 'api/v2/example')).to eq(response)
    end

    it 'specifies foreman_user header' do
      expect(consumer).to receive(:request).with(:get, anything, anything, anything, hash_including('foreman_user' => 'admin')).and_return(double(:code => '200'))
      provider.request(:get, 'api/v2/example')
    end

    it 'passes parameters' do
      expect(consumer).to receive(:request).with(:get, 'https://foreman.example.com/api/v2/example?test=value', anything, anything, anything).and_return(double(:code => '200'))
      provider.request(:get, 'api/v2/example', :test => 'value')
    end

    it 'passes data' do
      expect(consumer).to receive(:request).with(:post, anything, anything, anything, 'test', anything).and_return(double(:code => '200'))
      provider.request(:post, 'api/v2/example', {}, 'test')
    end

    it 'merges headers' do
      expect(consumer).to receive(:request).with(:get, anything, anything, anything, hash_including('test' => 'value', 'Accept' => 'application/json')).and_return(double(:code => '200'))
      provider.request(:get, 'api/v2/example', {}, nil, {'test' => 'value'})
    end

    describe 'with non-root base URL' do
      let(:base_url) { 'https://foreman.example.com/foreman' }
      it 'concatenates the base and request URLs' do
        expect(consumer).to receive(:request).with(:get, 'https://foreman.example.com/foreman/api/v2/example', anything, anything, anything).and_return(double(:code => '200'))
        provider.request(:get, 'api/v2/example')
      end
    end

    it 'retries on timeout' do
      expect(consumer).to receive(:request).twice.and_raise(Timeout::Error)
      expect(provider).to receive(:warning).with('Timeout calling API at https://foreman.example.com/api/v2/example. Retrying ..').twice
      expect(consumer).to receive(:request).and_return(double(:code => '200'))
      provider.request(:get, 'api/v2/example')
    end

    it 'fails resource after multiple timeouts' do
      expect(consumer).to receive(:request).exactly(5).times.and_raise(Timeout::Error)
      expect { provider.request(:get, 'api/v2/example') }.to raise_error(Puppet::Error, /Timeout/)
    end

    it 'fails resource with network errors' do
      expect(consumer).to receive(:request).and_raise(Errno::ECONNRESET)
      expect { provider.request(:get, 'api/v2/example') }.to raise_error(Puppet::Error, /Exception/)
    end
  end

  describe '#success?(response)' do
    it 'returns true for response code in 2xx' do
      expect(provider.success?(double(:code => '256'))).to eq(true)
    end

    it 'returns false for non-2xx response code' do
      expect(provider.success?(double(:code => '404'))).to eq(false)
    end
  end

  describe '#error_message(response)' do
    it 'returns array of errors from JSON' do
      expect(provider.error_message(double(:body => '{"error":{"full_messages":["error1","error2"]}}', :code => 'dummycode'))).to eq('error1 error2')
    end

    it 'returns message for unrecognized response code' do
      expect(provider.error_message(double(:body => '{}', :code => '418', :message => "I'm a teapot"))).to eq("Response: 418 I'm a teapot")
    end

    it 'returns message for 400 response' do
      expect(provider.error_message(double(:body => '{}', :code => '400', :message => 'Bad Request'))).to eq('Response: 400 Bad Request: Something is wrong with the data sent to Foreman server')
    end

    it 'returns message for 401 response' do
      expect(provider.error_message(double(:body => '{}', :code => '401', :message => 'Unauthorized Request'))).to eq('Response: 401 Unauthorized Request: Often this is caused by invalid Oauth credentials')
    end

    it 'returns message for 404 response' do
      expect(provider.error_message(double(:body => '{}', :code => '404', :message => 'Not Found'))).to eq('Response: 404 Not Found: The requested resource was not found')
    end

    it 'returns message for 500 response' do
      expect(provider.error_message(double(:body => '{}', :code => '500', :message => 'Internal Server Error'))).to eq('Response: 500 Internal Server Error: Check /var/log/foreman/production.log on Foreman server for detailed information')
    end

    it 'returns message for 502 response' do
      expect(provider.error_message(double(:body => '{}', :code => '502', :message => 'Bad Gateway'))).to eq('Response: 502 Bad Gateway: The webserver received an invalid response from the backend service. Was Foreman unable to handle the request?')
    end

    it 'returns message for 503 response' do
      expect(provider.error_message(double(:body => '{}', :code => '503', :message => 'Service Unavailable'))).to eq('Response: 503 Service Unavailable: The webserver was unable to reach the backend service. Is foreman.service running?')
    end

    it 'returns message for 504 response' do
      expect(provider.error_message(double(:body => '{}', :code => '504', :message => 'Gateway Timeout'))).to eq('Response: 504 Gateway Timeout: The webserver timed out waiting for a response from the backend service. Is Foreman under unusually heavy load?')
    end
  end
end
