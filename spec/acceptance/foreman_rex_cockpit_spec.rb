require 'spec_helper_acceptance'

describe 'Scenario: install foreman with rex cockpit', if: os[:family] == 'redhat' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include foreman
      include foreman::plugin::remote_execution::cockpit
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'

  describe port(19090) do
    it { is_expected.to be_listening.on('127.0.0.1').with('tcp') }
  end
end
