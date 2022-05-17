require 'spec_helper'

describe Puppet::Type.type(:foreman_global_parameter).provider(:rest_v3) do
  let(:resource) do
    Puppet::Type.type(:foreman_global_parameter).new(
      name: 'foo',
      base_url: 'https://foreman.example.com',
      consumer_key: 'oauth_key',
      consumer_secret: 'oauth_secret',
      effective_user: 'admin',
      parameter_type: 'string',
    )
  end

  let(:provider) do
    provider = described_class.new
    provider.resource = resource
    provider
  end

  describe '#hidden_value' do
    it 'has working getters/setters' do
      provider.hidden_value = 'foo'
      expect(provider.hidden_value).to eq 'foo'
    end
  end

  describe '#create' do
    it 'sends POST request' do
      data = {
        common_parameter: {
          name: 'foo',
          value: 'bar',
          parameter_type: 'string',
        }
      }.to_json

      expect(provider).to receive(:request)
        .with(:post, 'api/v2/common_parameters', {}, data)
        .and_return(double(:code => '201', :body => {'id' => 1, 'name' => 'proxy.example.com'}))
      resource[:value] = 'bar'
      provider.create
      provider.flush
    end
  end

  describe '#destroy' do
    it 'sends DELETE request' do
      expect(provider).to receive(:id).and_return(1)
      expect(provider).to receive(:request)
        .with(:delete, 'api/v2/common_parameters/1')
        .and_return(double(:code => '204'))
      provider.destroy
      provider.flush
    end
  end

  describe '#exists?' do
    let(:json) do
      <<~J
        {
          "total": 16,
          "subtotal": 1,
          "page": 1,
          "per_page": 100,
          "search": "name=foo",
          "sort": {
            "by": null,
            "order": null
          },
          "results": [{"created_at":"2021-11-22 10:43:04 -0700","updated_at":"2022-05-19 10:12:16 -0700","hidden_value?":false,"hidden_value":"*****","id":1,"name":"foo","parameter_type":"boolean","value":true}]
        }
      J
    end

    it 'sends GET request' do
      params = {
        search: "name=#{resource[:name]}",
        show_hidden: true
      }

      r = double(:code => '200')
      # debug messsage may use :body
      expect(r).to receive(:body).at_least(:once).and_return(json)
      expect(provider).to receive(:request)
        .with(:get, 'api/v2/common_parameters', params)
        .and_return(r)
      provider.exists?
      expect(provider.name).to eq 'foo'
      expect(provider.parameter_type).to eq 'boolean'
      expect(provider.value).to eq :true
      expect(provider.hidden_value).to eq :false
    end
  end
end
