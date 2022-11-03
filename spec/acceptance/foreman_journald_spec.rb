require 'spec_helper_acceptance'

describe 'Scenario: install foreman with journald' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'foreman':
        logging_type => 'journald',
      }
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'

  describe package('foreman-journald') do
    it { is_expected.to be_installed }
  end

  describe command('journalctl -u foreman') do
    its(:stdout) { is_expected.to match(%r{Redirected to https://#{host_inventory['fqdn']}/users/login}) }
  end

  describe command('journalctl -u dynflow-sidekiq@orchestrator') do
    its(:stdout) { is_expected.to match(%r{orchestrator in passive mode}) }
  end
end
