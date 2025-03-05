require 'spec_helper'

describe 'foreman::plugin::tasks' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:pre_condition) { 'include foreman' }

      let(:package_name) do
        case facts[:os]['family']
        when 'RedHat'
          'rubygem-foreman-tasks'
        when 'Debian'
          'ruby-foreman-tasks'
        end
      end

      it { should compile.with_all_deps }
      it { should contain_foreman__plugin('tasks').with_package(package_name) }
      it { should contain_file('/etc/cron.d/foreman-tasks').with_ensure('absent') }

      describe 'with automatic task cleanup' do
        let(:cron_line) { "30 10 * * *" }
        let(:params) do {
          :automatic_cleanup => true,
          :cron_line => cron_line
        } end

        it 'should deploy the cron job' do
          should contain_file('/etc/cron.d/foreman-tasks').
            with_content(%r{SHELL=/bin/sh}).
            with_content(%r{RAILS_ENV=production}).
            with_content(%r{FOREMAN_HOME=/usr/share/foreman}).
            with_content(%r{TASK_BACKUP=false}).
            with_content(%r{/usr/sbin/foreman-rake foreman_tasks:cleanup}).
            with_content(%r{#{cron_line}}).
            with_ensure('file')
        end
      end
    end
  end
end
