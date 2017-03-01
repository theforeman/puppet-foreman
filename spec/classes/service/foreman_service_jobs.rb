require 'spec_helper'

describe 'foreman::service::jobs' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include foreman' }

      it { should compile.with_all_deps }

      if os =~ /redhat/i
        it { should contain_service('dynflow-executor').with({
          'ensure'    => 'running',
          'enable'    => true,
          'name'      => 'dynflow-executor'
        })}
      elsif os =~ /debian/i
        it { should contain_service('ruby-dynflow-executor').with({
          'ensure'    => 'running',
          'enable'    => true,
          'name'      => 'ruby-dynflow-executor'
        })}
      end
    end
  end
end
