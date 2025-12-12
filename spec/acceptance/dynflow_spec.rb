require 'spec_helper_acceptance'

describe 'Scenario: install foreman', order: :defined do
  before(:context) { purge_foreman }
  context '2 workers' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'foreman':
          dynflow_worker_instances => 2,
        }
        PUPPET
      end
    end

    it_behaves_like 'the foreman application'

    describe file('/etc/foreman/dynflow/worker.yml') do
      it { is_expected.not_to exist }
    end

    describe service('dynflow-sidekiq@worker') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end

    describe file('/etc/foreman/dynflow/worker-1.yml') do
      it { is_expected.to be_file }
    end

    describe service('dynflow-sidekiq@worker-1') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe file('/etc/foreman/dynflow/worker-2.yml') do
      it { is_expected.to be_file }
    end

    describe service('dynflow-sidekiq@worker-2') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  context '1 worker' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'foreman':
          dynflow_worker_instances => 1,
        }
        PUPPET
      end
    end

    it_behaves_like 'the foreman application'

    describe file('/etc/foreman/dynflow/worker.yml') do
      it { is_expected.not_to exist }
    end

    describe service('dynflow-sidekiq@worker') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end

    describe file('/etc/foreman/dynflow/worker-1.yml') do
      it { is_expected.to be_file }
    end

    describe service('dynflow-sidekiq@worker-1') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe file('/etc/foreman/dynflow/worker-2.yml') do
      it { is_expected.not_to be_file }
    end

    describe service('dynflow-sidekiq@worker-2') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end
  end
end
