require 'spec_helper'

describe 'foreman::plugin::tasks' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:pre_condition) { 'include foreman' }

      case facts[:osfamily]
      when 'RedHat'
        package_name = case facts[:operatingsystem]
                       when 'Fedora'
                         'rubygem-foreman-tasks'
                       else
                         'tfm-rubygem-foreman-tasks'
                       end
      when 'Debian'
        package_name = 'ruby-foreman-tasks'
      else
        package_name = 'foreman-tasks'
      end

      it { should compile.with_all_deps }

      it { should contain_class('foreman::service::jobs') }

      it 'should call the plugin' do
        should contain_foreman__plugin('tasks').with_package(package_name)
        should contain_file('/etc/cron.d/foreman-tasks').
          with_path('/etc/cron.d/foreman-tasks').
          with_ensure('absent')
      end

      describe 'with automatic task cleanup' do
        let(:cron_line) { "30 10 * * *" }
        let(:params) do {
          :automatic_cleanup => true,
          :cron_line => cron_line
        } end

        it 'should deploy the cron job' do
          should contain_file('/etc/cron.d/foreman-tasks').
            with_path('/etc/cron.d/foreman-tasks').
            with_content(%r{SHELL=/bin/sh}).
            with_content(%r{RAILS_ENV=production}).
            with_content(%r{FOREMAN_HOME=/usr/share/foreman}).
            with_content(%r{/usr/sbin/foreman-rake foreman_tasks:cleanup}).
            with_content(%r{#{cron_line}}).
            with_ensure('present')
        end
      end
    end
  end
end
