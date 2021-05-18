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

  # Logging to the journal is broken on Docker 18+ and EL7 but works in Vagrant
  # VMs (and EL7's Docker version)
  broken_journald_logging = ENV['BEAKER_HYPERVISOR'] == 'docker' && os[:family] == 'redhat' && os[:release] =~ /^7\./

  describe command('journalctl -u foreman'), unless: broken_journald_logging do
    its(:stdout) { is_expected.to match(%r{Redirected to https://#{host_inventory['fqdn']}/users/login}) }
  end

  describe command('journalctl -u dynflow-sidekiq@orchestrator'), unless: broken_journald_logging do
    its(:stdout) { is_expected.to match(%r{Everything ready for world: }) }
  end
end
