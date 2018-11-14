require 'spec_helper'

describe 'foreman::repos::extra' do
  on_os_under_test.each do |os, facts|
    context "on #{os}", if: facts[:osfamily] == 'RedHat' do
      let(:facts) { facts }

      describe 'when repos are fully enabled' do
        let(:params) do
          {
            configure_scl_repo: true,
            configure_epel_repo: true
          }
        end

        it do
          is_expected.to contain_yumrepo('epel')
            .with_mirrorlist("https://mirrors.fedoraproject.org/metalink?repo=epel-#{facts[:operatingsystemmajrelease]}&arch=$basearch")
            .with_gpgcheck(1)
            .with_gpgkey('https://fedoraproject.org/static/352C64E5.txt')
        end
        it { is_expected.to contain_package('foreman-release-scl').with_ensure('installed') }
      end

      describe 'when scl repo set to latest' do
        let(:params) do
          {
            configure_scl_repo: true,
            configure_epel_repo: true,
            scl_repo_ensure: 'latest'
          }
        end

        it { is_expected.to contain_package('foreman-release-scl').with_ensure('latest') }
      end

      describe 'when fully disabled' do
        let(:params) do
          {
            configure_scl_repo: false,
            configure_epel_repo: false
          }
        end

        it { is_expected.to_not contain_yumrepo('epel') }
        it { is_expected.to_not contain_package('foreman-release-scl') }
      end
    end
  end
end
