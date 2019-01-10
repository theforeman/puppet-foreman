require 'spec_helper'

describe 'foreman::repo' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with explicit parameters' do
        let :params do
          {
            repo: '1.19',
            gpgcheck: true,
            configure_epel_repo: false,
            configure_scl_repo: false
          }
        end

        it { is_expected.to compile.with_all_deps }

        it 'should include OS repos' do
          is_expected.to contain_foreman__repos('foreman')
            .with_repo('1.19')
            .with_gpgcheck(true)
        end

        it 'should include extra repos' do
          is_expected.to contain_class('foreman::repos::extra')
            .with_configure_epel_repo(false)
            .with_configure_scl_repo(false)
        end
      end
    end
  end
end
