require 'spec_helper'

describe 'foreman::dynflow::worker' do
  let :title do 'test_worker' end

  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let :pre_condition do
        'include foreman'
      end

      context 'default parameters' do
        it {
          should contain_file('/etc/foreman/dynflow/test_worker.yml')
            .with_ensure('file')
            .with_owner('root')
            .with_group('foreman')
            .with_mode('0644')
            .with_content(/:concurrency: 5/)
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
