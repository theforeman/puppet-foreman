require 'spec_helper_acceptance'

describe 'Scenario: install foreman-cli without foreman' do
  before(:context) { purge_foreman }

  let(:pp) do
    <<-PUPPET
    class { 'foreman::cli':
      foreman_url => 'https://foreman.example.com',
      username    => 'admin',
      password    => 'changeme',
    }
    PUPPET
  end

  it_behaves_like 'a idempotent resource'

  it_behaves_like 'hammer'
end
