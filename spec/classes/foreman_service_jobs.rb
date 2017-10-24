require 'spec_helper'

describe 'foreman::service::jobs' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:service_name) do
        facts[:osfamily] == 'Debian' ? 'ruby-foreman-tasks' : 'foreman-tasks'
      end

      it { should compile.with_all_deps }
      it { should contain_service(service_name).with_ensure('running').with_enable(true) }
    end
  end
end
