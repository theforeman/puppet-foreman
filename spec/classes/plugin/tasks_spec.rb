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
        service_name = 'foreman-tasks'
      when 'Debian'
        package_name = 'ruby-foreman-tasks'
        service_name = 'ruby-foreman-tasks'
      else
        package_name = 'foreman-tasks'
        service_name = 'foreman-tasks'
      end

      it { should compile.with_all_deps }

      it 'should call the plugin' do
        should contain_foreman__plugin('tasks').with_package(package_name)
        should contain_service('foreman-tasks').with('ensure' => 'running', 'enable' => 'true', 'name' => service_name)
        should contain_file('foreman-tasks-cleanup-cron').
          with_path('/etc/cron.d/foreman-tasks-cleanup').
          with_ensure('absent')
      end

      describe 'with automatic task cleanup' do
        let(:params) do {
          :automatic_cleanup => true
        } end

        it 'should deploy the cron job' do
          should contain_file('foreman-tasks-cleanup-cron').
            with_path('/etc/cron.d/foreman-tasks-cleanup').
            with_content(%r{SHELL=/bin/sh}).
            with_content(%r{RAILS_ENV=production}).
            with_content(%r{FOREMAN_HOME=/usr/share/foreman}).
            with_content(%r{/usr/sbin/foreman-rake foreman_tasks:cleanup}).
            with_ensure('present')
        end
      end
    end
  end
end
