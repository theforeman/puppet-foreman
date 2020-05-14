require 'spec_helper'

describe 'foreman::dynflow::pool' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'myworker' }
      let(:params) do
        {
          instances: 1,
          concurrency: 5,
        }
      end

      context 'with default parameters' do
        it { is_expected.to compile.and_raise_error(/parameter 'queues' expects size to be at least 1, got 0/) }
      end

      context 'with the queue overridden' do
        let(:params) { super().merge(queues: ['myqueue']) }

        let :pre_condition do
          <<-PUPPET
          class { 'foreman':
            dynflow_manage_services => false,
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_foreman__dynflow__worker('myworker-1')
            .with_queues(['myqueue'])
            .with_concurrency(5)
        end

        context 'with the concurrency overridden' do
          let(:params) { super().merge(concurrency: 42) }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_foreman__dynflow__worker('myworker-1').with_concurrency(42) }
        end

        context 'without the custom fact' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_foreman__dynflow__worker('myworker-1').with_ensure('present') }
          it { is_expected.to contain_foreman__dynflow__worker('myworker').with_ensure('absent') }
          it { is_expected.not_to contain_foreman__dynflow__worker('myworker-0') }
          it { is_expected.not_to contain_foreman__dynflow__worker('myworker-2') }
        end

        context 'with the custom fact' do
          let(:facts) { super().merge(foreman_dynflow: custom_fact) }

          context 'that returns an empty array' do
            let(:custom_fact) { [] }

            it { is_expected.to compile.with_all_deps }
          end

          context 'that returns a matching service' do
            let(:custom_fact) { ['myworker-1'] }

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_foreman__dynflow__worker('myworker-1').with_ensure('present') }
          end

          context 'that returns an additional service' do
            let(:custom_fact) { ['myworker-1', 'myworker-2'] }

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_foreman__dynflow__worker('myworker-1').with_ensure('present') }
            it { is_expected.to contain_foreman__dynflow__worker('myworker-2').with_ensure('absent') }

            context 'with 2 instances desired' do
              let(:params) { super().merge(instances: 2) }

              it { is_expected.to compile.with_all_deps }
              it { is_expected.to contain_foreman__dynflow__worker('myworker-1').with_ensure('present') }
              it { is_expected.to contain_foreman__dynflow__worker('myworker-2').with_ensure('present') }
            end
          end
        end
      end
    end
  end
end
