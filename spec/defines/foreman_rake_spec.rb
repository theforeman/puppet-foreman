require 'spec_helper'

describe 'foreman::rake' do
  let(:title) { 'db:migrate' }

  os, os_facts = on_supported_os.first
  context "on #{os}" do
    let(:facts) { os_facts }

    # These parameters are inherited normally, but here we cheat for performance
    let :params do
      {
        user: 'foreman',
        app_root: '/usr/share/foreman'
      }
    end

    context 'without parameters' do
      it do
        should contain_exec('foreman-rake-db:migrate')
          .with_command('/usr/sbin/foreman-rake db:migrate')
          .with_user('foreman')
          .with_environment(['HOME=/usr/share/foreman'])
          .with_logoutput(true)
          .with_refreshonly(true)
          .with_timeout(nil)
          .with_unless(nil)
      end
    end

    context 'with environment' do
      let(:params) { super().merge(environment: { 'SEED_USER' => 'admin' }) }

      it do
        should contain_exec('foreman-rake-db:migrate')
          .with_command('/usr/sbin/foreman-rake db:migrate')
          .with_user('foreman')
          .with_environment(['HOME=/usr/share/foreman', 'SEED_USER=admin'])
          .with_logoutput(true)
          .with_refreshonly(true)
      end
    end

    context 'with timeout' do
      let(:params) { super().merge(timeout: 60) }

      it do
        should contain_exec('foreman-rake-db:migrate')
          .with_command('/usr/sbin/foreman-rake db:migrate')
          .with_user('foreman')
          .with_environment(['HOME=/usr/share/foreman'])
          .with_timeout(60)
          .with_logoutput(true)
          .with_refreshonly(true)
      end
    end

    context 'with unless' do
      let(:params) { super().merge(unless: '/usr/bin/true') }

      it do
        should contain_exec('foreman-rake-db:migrate')
          .with_command('/usr/sbin/foreman-rake db:migrate')
          .with_user('foreman')
          .with_environment(['HOME=/usr/share/foreman'])
          .with_logoutput(true)
          .with_refreshonly(false)
          .with_unless('/usr/bin/true')
      end
    end
  end
end
