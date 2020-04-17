require 'spec_helper_acceptance'

describe 'Scenario: install foreman' do
  before(:context) { purge_foreman }

  let(:pp) do
    <<-PUPPET
    include foreman
    PUPPET
  end

  it_behaves_like 'a idempotent resource'

  it_behaves_like 'the foreman application'

  describe package('foreman-journald') do
    it { is_expected.not_to be_installed }
  end

  describe package('foreman-telemetry') do
    it { is_expected.not_to be_installed }
  end
end
