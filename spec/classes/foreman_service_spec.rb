require 'spec_helper'

describe 'foreman::service' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :params do
    {
      passenger: true,
      app_root: '/usr/share/foreman',
      ssl: true,
      jobs_service: 'dynflower',
      jobs_service_ensure: 'stopped',
      jobs_service_enable: false
    }
  end

  context 'with passenger' do
    let(:params) { super().merge(passenger: true) }
    let(:pre_condition) { 'include ::apache' }

    context 'with ssl' do
      let(:params) { super().merge(ssl: true) }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_service('dynflower').with_ensure('stopped').with_enable(false) }

      it 'should restart passenger' do
        should contain_exec('restart_foreman')
          .with_command('/bin/touch /usr/share/foreman/tmp/restart.txt')
          .with_refreshonly(true)
          .with_cwd('/usr/share/foreman')
          .with_path('/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin')
      end

      it { should contain_service('httpd').that_comes_before('Class[foreman::service]') }
      it { should contain_class('apache::service').that_comes_before('Class[foreman::service]') }

      it do
        should contain_service('foreman')
          .with_ensure('stopped')
          .with_enable(false)
          .with_hasstatus(true)
      end
    end

    context 'without ssl' do
      let(:params) { super().merge(ssl: false) }
      it { is_expected.to compile.with_all_deps }
    end
  end

  context 'without passenger' do
    let(:params) { super().merge(passenger: false) }
    it { is_expected.to compile.with_all_deps }
    it { should_not contain_exec('restart_foreman') }
    it do
      should contain_service('foreman')
        .with_ensure('running')
        .with_enable(true)
        .with_hasstatus(true)
    end
  end
end
