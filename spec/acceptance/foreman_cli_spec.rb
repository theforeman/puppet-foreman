require 'spec_helper_acceptance'

describe 'Scenario: install foreman-cli without foreman' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
        class { 'foreman::cli':
          foreman_url => 'https://foreman.example.com',
          username    => 'admin',
          password    => 'changeme',
        }
      PUPPET
    end
  end

  it_behaves_like 'hammer'
end
