require 'spec_helper'

describe 'foreman' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { {} }

      describe 'with version' do
        let(:params) { super().merge(version: 'latest') }
        it { should contain_foreman__repos('foreman') }
        it { should contain_package('foreman-postgresql').with_ensure('latest') }
      end

      describe 'with custom repo' do
        let(:params) { super().merge(custom_repo: true) }
        it { should contain_class('foreman::repo') }
        it { should_not contain_foreman__repos('foreman') }
        it { should contain_package('foreman-postgresql') }
      end

      context 'with SELinux enabled' do
        let(:facts) { super().merge(selinux: true) }

        describe 'with selinux => false' do
          let(:params) { super().merge(selinux: false) }
          it { should_not contain_package('foreman-selinux') }
        end

        describe 'with selinux => true' do
          let(:params) { super().merge(selinux: true) }
          it { should contain_package('foreman-selinux') }
        end

        describe 'with selinux => undef' do
          it { should contain_package('foreman-selinux') }
        end
      end

      context 'with SELinux disabled' do
        let(:facts) { super().merge(selinux: false) }

        describe 'with selinux => false' do
          let(:params) { super().merge(selinux: false) }
          it { should_not contain_package('foreman-selinux') }
        end

        describe 'with selinux => true' do
          let(:params) { super().merge(selinux: true) }
          it { should contain_package('foreman-selinux') }
        end

        describe 'with selinux => undef' do
          it { should_not contain_package('foreman-selinux') }
        end
      end
    end
  end
end
