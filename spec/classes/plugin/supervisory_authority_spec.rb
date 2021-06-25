require 'spec_helper'

describe 'foreman::plugin::supervisory_authority' do
  let(:params) do
    {
      'server_url'   => 'https://example.com',
      'secret_token' => 'secret_example',
      'service_name' => 'foreman prod',
    }
  end
  include_examples 'basic foreman plugin tests', 'supervisory_authority'
  it { is_expected.to contain_foreman__plugin('supervisory_authority').with_config(%r{^---\n:foreman_supervisory_authority:\n  server_url: https://example\.com\n}) }
end
