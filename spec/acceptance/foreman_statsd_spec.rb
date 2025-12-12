require 'spec_helper_acceptance'

describe 'Scenario: install foreman with statsd' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'foreman':
        telemetry_statsd_enabled => true,
      }
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'

  describe package('foreman-telemetry') do
    it { is_expected.to be_installed }
  end
  describe command("journalctl --boot --no-pager") do
    its(:stdout) { should match /foreman/ } # we need to match anything, otherwise beaker/serverspec won't print the command output on stdout
    its(:exit_status) { should eq 0 }
  end
  # TODO: actually verify statsd functionality
end
