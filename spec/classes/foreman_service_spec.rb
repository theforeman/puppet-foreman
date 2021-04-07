require 'spec_helper'

describe 'foreman::service' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :params do
    {
      ssl: true,
      foreman_service: 'foreman',
      foreman_service_ensure: 'running',
      foreman_service_enable: true,
      dynflow_manage_services: false,
      dynflow_orchestrator_ensure: 'present',
      dynflow_worker_instances: 1,
      dynflow_worker_concurrency: 5,
    }
  end

  context 'without apache' do
    let(:params) { super().merge(apache: false) }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_service('foreman.socket').with_ensure('running').with_enable(true) }
    it { is_expected.to contain_service('foreman').with_ensure('running').with_enable(true) }
  end

  context 'with apache' do
    # Mock the apache service
    let(:pre_condition) { 'class apache::service {} include apache::service' }
    let(:params) { super().merge(apache: true) }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('foreman::service').that_requires('Class[apache::service]') }
    it { is_expected.to contain_service('foreman.socket').with_ensure('running').with_enable(true) }
    it { is_expected.to contain_service('foreman').with_ensure('running').with_enable(true) }

    context 'without ssl' do
      let(:params) { super().merge(ssl: false) }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
