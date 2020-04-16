require 'spec_helper'

describe 'foreman' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { {} }

      describe 'with version' do
        let(:params) { super().merge(version: 'latest') }
        it { should_not contain_foreman__repos('foreman') }
        it { should contain_package('foreman-postgresql').with_ensure('latest') }
      end

      describe 'with repo' do
        let(:params) { super().merge(repo: 'nightly') }
        it { should contain_class('foreman::repo') }
        it { should contain_foreman__repos('foreman') }
        it { should contain_package('foreman-postgresql').that_requires('Class[foreman::repo]') }
      end

      describe 'sidekiq jobs' do
        context 'with jobs_manage_service disabled' do
          let(:params) { super().merge(jobs_manage_service: false) }
          it { is_expected.not_to contain_package('foreman-dynflow-sidekiq') }
        end
        context 'with jobs_manage_service enabled' do
          let(:params) { super().merge(jobs_manage_service: true) }
          it { is_expected.to contain_package('foreman-dynflow-sidekiq') }
        end
      end

      context 'with SELinux enabled' do
        let(:facts) { super().merge(selinux: true) }
        it { should contain_package('foreman-selinux') }
      end

      context 'with SELinux disabled' do
        let(:facts) { super().merge(selinux: false) }
        it { should_not contain_package('foreman-selinux') }
      end
    end
  end
end
