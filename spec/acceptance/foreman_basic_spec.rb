require 'spec_helper_acceptance'

describe 'Scenario: install foreman' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) { 'include foreman' }
  end

  it_behaves_like 'the foreman application'

  describe package('foreman-journald') do
    it { is_expected.not_to be_installed }
  end

  describe package('foreman-telemetry') do
    it { is_expected.not_to be_installed }
  end

  context 'GSSAPI auth enabled' do
    it_behaves_like 'the foreman application' do
      let(:manifest) do
        <<-PUPPET
        class { 'foreman':
          ipa_authentication => true,
          ipa_authentication_api => true,
        }
        PUPPET
      end
    end
  end
end
