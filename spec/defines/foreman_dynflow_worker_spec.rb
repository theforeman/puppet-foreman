require 'spec_helper'

describe 'foreman::dynflow::worker' do
  let(:title) { 'test_worker' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'ensure => present' do
        let(:params) do
          {ensure: 'absent'}
        end

        it { should compile.with_all_deps }
        it do
          should contain_file('/etc/foreman/dynflow/test_worker.yml')
            .with_ensure('absent')
        end
        it do
          should contain_service('dynflow-sidekiq@test_worker')
            .with_ensure('stopped')
            .with_enable(false)
        end
      end

      context 'ensure => present' do
        let :pre_condition do
          <<-PUPPET
          class { 'foreman':
            dynflow_manage_services => false,
          }
          PUPPET
        end

        context 'default parameters' do
          it { should compile.and_raise_error(/expects size to be at least 1, got 0/) }
        end

        context 'with multiple queues' do
          let(:params) do
            {queues: ['default', 'remote_execution']}
          end

          it { should compile.with_all_deps }
          it {
            should contain_file('/etc/foreman/dynflow/test_worker.yml')
              .with_ensure('file')
              .with_owner('root')
              .with_group('foreman')
              .with_mode('0644')
              .with_content(/:concurrency: 1/)
              .with_content(/:queues:\n  - default\n  - remote_execution/)
          }
          it {
            should contain_service('dynflow-sidekiq@test_worker')
              .with_ensure('running')
              .with_enable(true)
          }
        end

        context 'with custom concurrency and queues' do
          let :params do
            {
              concurrency: 10,
              queues: ['katello']
            }
          end

          it { should compile.with_all_deps }
          it { should contain_file('/etc/foreman/dynflow/test_worker.yml')
              .with_ensure('file')
              .with_owner('root')
              .with_group('foreman')
              .with_mode('0644')
              .with_content(/:concurrency: 10/)
              .with_content(/:queues:\n  - katello\n$/) }
        end
      end
    end
  end
end
