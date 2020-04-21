require 'spec_helper'

describe 'foreman::plugin::remote_execution' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:pre_condition) { 'include foreman' }

      it { should compile.with_all_deps }
      it { should contain_foreman__plugin('remote_execution').that_notifies("Class[foreman::service]") }
      it { should contain_foreman__plugin('tasks') }
    end
  end
end
