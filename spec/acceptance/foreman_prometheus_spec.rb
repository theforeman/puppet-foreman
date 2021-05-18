require 'spec_helper_acceptance'

describe 'Scenario: install foreman with prometheus' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'foreman':
        telemetry_prometheus_enabled => true,
      }
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'

  describe package('foreman-telemetry') do
    it { is_expected.to be_installed }
  end

  # TODO: actually verify prometheus functionality
end
