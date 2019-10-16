require 'spec_helper'

describe 'foreman::service' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :params do
    {
      passenger: true,
      apache: true,
      app_root: '/usr/share/foreman',
      ssl: true,
      use_foreman_service: false,
      foreman_service: 'foreman',
      foreman_service_ensure: 'running',
      foreman_service_enable: true,
      jobs_manage_service: false
    }
  end

  context 'with passenger' do
    let(:params) { super().merge(passenger: true) }
    let(:pre_condition) { 'include ::apache' }

    context 'with ssl' do
      let(:params) { super().merge(ssl: true) }
      it { is_expected.to compile.with_all_deps }

      it 'should restart passenger' do
        should contain_exec('restart_foreman')
          .with_command('/bin/touch /usr/share/foreman/tmp/restart.txt')
          .with_refreshonly(true)
          .with_cwd('/usr/share/foreman')
          .with_path('/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin')
      end

      it { should contain_service('httpd').that_comes_before('Class[foreman::service]') }
      it { should contain_class('apache::service').that_comes_before('Class[foreman::service]') }
      it { should_not contain_service('foreman') }
    end

    context 'without ssl' do
      let(:params) { super().merge(ssl: false) }
      it { is_expected.to compile.with_all_deps }
    end
  end

  context 'without apache' do
    let(:params) { super().merge(apache: false, use_foreman_service: true) }
    it { is_expected.to compile.with_all_deps }
    it { should_not contain_exec('restart_foreman') }
    it { should contain_service('foreman').with_ensure('running').with_enable(true) }
  end

  context 'without passenger' do
    let(:pre_condition) { 'class apache::service {} include apache::service' }
    let(:params) { super().merge(passenger: false, use_foreman_service: true) }
    it { is_expected.to compile.with_all_deps }
    it { should_not contain_exec('restart_foreman') }
    it do
      should contain_service('foreman')
        .with_ensure('running')
        .with_enable(true)
    end
  end
end
