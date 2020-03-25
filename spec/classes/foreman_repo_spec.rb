require 'spec_helper'

describe 'foreman::repo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_anchor('foreman::repo') }
        it { is_expected.not_to contain_foreman__repos('foreman') }

        it do
          if facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] == '7'
            is_expected.to contain_package('foreman-release-scl')
          else
            is_expected.not_to contain_package('foreman-release-scl')
          end
        end
      end

      describe 'with minimal parameters' do
        let(:params) { {repo: 'nightly'} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman__repos('foreman').with_repo('nightly').with_gpgcheck(true) }

        it do
          if facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] == '7'
            is_expected.to contain_package('foreman-release-scl')
          else
            is_expected.not_to contain_package('foreman-release-scl')
          end
        end
      end

      describe 'with explicit parameters' do
        let :params do
          {
            repo: '1.19',
            configure_scl_repo: false
          }
        end

        it { is_expected.to compile.with_all_deps }

        it 'should include OS repos' do
          is_expected.to contain_foreman__repos('foreman')
            .with_repo('1.19')
            .with_gpgcheck(true)
        end

        it { is_expected.not_to contain_package('foreman-release-scl') }
      end
    end
  end
end
