require 'spec_helper'

describe 'foreman::rake' do
  let(:title) { 'db:migrate' }

  context 'on RedHat' do
    let :facts do
      on_supported_os['redhat-7-x86_64']
    end

    context 'without parameters' do
      # These parameters are inherited normally, but here we cheat for performance
      let :params do
        {
          user: 'foreman',
          app_root: '/usr/share/foreman'
        }
      end

      it {
        should contain_exec('foreman-rake-db:migrate')
          .with_command('/usr/sbin/foreman-rake db:migrate')
          .with_user('foreman')
          .with_environment(['HOME=/usr/share/foreman'])
          .with_logoutput('on_failure')
          .with_refreshonly(true)
      }
    end

    context 'with environment' do
      let :params do
        {
          environment: { 'SEED_USER' => 'admin' },
          user: 'foreman',
          app_root: '/usr/share/foreman'
        }
      end

      it {
        should contain_exec('foreman-rake-db:migrate')
          .with_command('/usr/sbin/foreman-rake db:migrate')
          .with_user('foreman')
          .with_environment(['HOME=/usr/share/foreman', 'SEED_USER=admin'])
          .with_logoutput('on_failure')
          .with_refreshonly(true)
          .with_timeout(nil)
      }
    end

    context 'with timeout' do
      let :params do
        {
          timeout: 60,
          user: 'foreman',
          app_root: '/usr/share/foreman'
        }
      end

      it {
        should contain_exec('foreman-rake-db:migrate')
          .with_command('/usr/sbin/foreman-rake db:migrate')
          .with_user('foreman')
          .with_environment(['HOME=/usr/share/foreman'])
          .with_timeout(60)
          .with_logoutput('on_failure')
          .with_refreshonly(true)
      }
    end
  end
end
