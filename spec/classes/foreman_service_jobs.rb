require 'spec_helper'

describe 'foreman::service::jobs' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with inherited parameters' do
        context 'dynflow_in_core => true' do
          let(:pre_condition) do
            'include ::foreman'
          end

          it { should compile.with_all_deps }
          it { should contain_service('dynflowd').with_ensure('running').with_enable(true) }
        end

        context 'dynflow_in_core => false' do
          let(:pre_condition) do
            <<-EOS
            class { '::foreman':
              dynflow_in_core => false,
            }
            EOS
          end

          let(:service_name) do
            facts[:osfamily] == 'Debian' ? 'ruby-foreman-tasks' : 'foreman-tasks'
          end

          it { should compile.with_all_deps }
          it { should contain_service(service_name).with_ensure('running').with_enable(true) }
        end
      end

      context 'with explicit parameters' do
        let(:params) do
          {
            :service         => 'dynflower',
            :dynflow_in_core => true,
            :ensure          => 'running',
            :enable          => true,
          }
        end

        it { should compile.with_all_deps }
        it { should contain_service('dynflower').with_ensure('running').with_enable(true) }
      end
    end
  end
end
