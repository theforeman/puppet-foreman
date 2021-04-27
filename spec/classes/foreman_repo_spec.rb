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
          if facts[:operatingsystem] == 'CentOS' && facts[:operatingsystemmajrelease] == '7'
            is_expected.to contain_package('centos-release-scl-rh')
          else
            is_expected.not_to contain_package('centos-release-scl-rh')
          end
        end
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
          if facts[:operatingsystem] == 'CentOS' && facts[:operatingsystemmajrelease] == '7'
            is_expected.to contain_package('centos-release-scl-rh')
          else
            is_expected.not_to contain_package('centos-release-scl-rh')
          end
        end

        it do
          if facts[:operatingsystemmajrelease] == '8'
            is_expected.to contain_package('ruby:2.7')
          else
            is_expected.not_to contain_package('ruby:2.7')
          end
        end
      end

      describe 'with explicit parameters' do
        let :params do
          {
            repo: '1.19',
            configure_scl_repo: false,
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

        it { is_expected.not_to contain_package('centos-release-scl-rh') }

        it do
          is_expected.not_to contain_package('ruby:2.7')
        end
      end

      describe 'with repo set to 2.5' do
        let :params do
          {
            repo: '2.5',
            configure_scl_repo: false
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          if facts[:operatingsystemmajrelease] == '8'
            is_expected.to contain_package('ruby:2.7')
          else
            is_expected.not_to contain_package('ruby:2.7')
          end
        end
      end
    end
  end
end
