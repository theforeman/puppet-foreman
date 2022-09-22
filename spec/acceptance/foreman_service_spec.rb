require 'spec_helper_acceptance'

describe 'configures puma worker count', :order => :defined do
  context 'initial configuration with 2 puma workers' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'foreman':
          foreman_service_puma_workers => 2,
        }
        PUPPET
      end
    end

    describe service("foreman") do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe process('puma: cluster worker') do
      its(:count) { is_expected.to eq 2 }
    end
  end

  context 'reconfigure to use 1 puma worker and restart foreman.service' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'foreman':
          foreman_service_puma_workers => 1,
        }
        PUPPET
      end
    end

    describe service("foreman") do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe process('puma: cluster worker') do
      its(:count) { is_expected.to eq 1 }
    end
  end
end
