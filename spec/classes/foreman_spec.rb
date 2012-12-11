require 'spec_helper'


describe 'foreman', :type => :class  do

  let(:pre_condition) {
    '
      class apache::ssl {}
      class passenger {}
    '
  }
  context 'on debian' do
    let (:facts) do
      {
        :ipaddress => '10.0.0.1',
        :operatingsystem => 'Debian',
      }
    end

    describe 'with no custom parameters' do
      ## install
      it { should include_class('foreman::install') }
      it { should contain_package('foreman').with_ensure('present') }
      it { should contain_package('foreman-sqlite3').with_ensure('present') }
      # TODO: Test repos and require Repo.

      ## config
      it { should include_class('foreman::config') }
      it { should contain_user('foreman') }
      it { should contain_file('/etc/foreman/settings.yaml') }
      it { should contain_cron('clear_session_table') }
      # TODO: Check more parameters of cron.
      it { should include_class('foreman::config::reports') }
      it { should contain_cron('expire_old_reports') }
      it { should contain_cron('daily summary') }

      it { should include_class('foreman::config::passenger') }
      it { should contain_file('foreman_vhost') }
      it { should contain_exec('restart_foreman') }
      # TODO: Check config.ru and environment.rb file.

      ## service
      it { should include_class('foreman::service') }
      it { should contain_service('foreman').with_hasstatus(true).with({ :ensure => 'stopped', :enable => false, }) }
    end
  end

  # TODO: foreman::service Check service parameters depending on passenger.
  # TODO: foreman::config::passenger: Check foreman vhost path depending on OS / Apache module.

end
