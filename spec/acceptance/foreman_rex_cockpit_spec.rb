require 'spec_helper_acceptance'

describe 'Scenario: install foreman with rex cockpit', if: os[:family] == 'centos' do
  before(:context) { purge_foreman }

  let(:pp) do
    <<-PUPPET
    include foreman
    include foreman::plugin::remote_execution::cockpit
    PUPPET
  end

  it_behaves_like 'a idempotent resource'

  it_behaves_like 'the foreman application'

  describe port(19090) do
    it { is_expected.to be_listening.on('127.0.0.1').with('tcp') }
  end
end
