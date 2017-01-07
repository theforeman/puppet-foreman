require 'spec_helper'

describe 'foreman::plugin::remote_execution' do
  on_os_under_test.each do |os, facts|
    let(:facts) { facts }

    let(:pre_condition) { 'include foreman' }

    context "on #{os}" do
      it { should contain_foreman__plugin('remote_execution').that_notifies('Service[foreman-tasks]') }
      it { should contain_foreman__plugin('tasks') }
    end
  end
end
