require 'spec_helper_acceptance'

describe 'Scenario: install foreman with statsd' do
  before(:context) { purge_foreman }

  let(:pp) do
    <<-PUPPET
    class { 'foreman':
      telemetry_statsd_enabled => true,
    }
    PUPPET
  end

  it_behaves_like 'a idempotent resource'

  it_behaves_like 'the foreman application'

  describe package('foreman-telemetry') do
    it { is_expected.to be_installed }
  end

  # TODO: actually verify statsd functionality
end
