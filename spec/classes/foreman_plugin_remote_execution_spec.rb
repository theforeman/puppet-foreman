require 'spec_helper'

describe 'foreman::plugin::remote_execution' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    let(:facts) { facts }

    context "on #{os}" do
      it { should contain_foreman__plugin('remote_execution').that_notifies('Service[foreman-tasks]') }
      it { should contain_foreman__plugin('tasks') }
    end
  end
end
