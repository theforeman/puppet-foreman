require 'spec_helper'

describe 'foreman::repo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_anchor('foreman::repo') }
        it { is_expected.not_to contain_foreman__repos('foreman') }
      end

      describe 'with minimal parameters' do
        let(:params) { {repo: 'nightly'} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman__repos('foreman')
          .with_repo('nightly')
          .with_gpgcheck(true)
          .with_yum_repo_baseurl('https://yum.theforeman.org')
        }

        it do
          if facts[:osfamily] == 'RedHat'
            is_expected.to contain_package('foreman').with_ensure('el8').with_provider('dnfmodule')
          else
            is_expected.not_to contain_package('foreman')
          end
        end
      end

      describe 'with explicit parameters' do
        let :params do
          {
            repo: '1.19',
            yum_repo_baseurl: 'https://example.org'
          }
        end

        it { is_expected.to compile.with_all_deps }

        it 'should include OS repos' do
          is_expected.to contain_foreman__repos('foreman')
            .with_repo('1.19')
            .with_gpgcheck(true)
            .with_yum_repo_baseurl('https://example.org')
        end
      end
    end
  end
end
