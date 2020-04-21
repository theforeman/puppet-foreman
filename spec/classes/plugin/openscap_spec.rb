require 'spec_helper'

describe 'foreman::plugin::openscap' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:pre_condition) { 'include foreman' }

      it { should compile.with_all_deps }

      it 'should call the plugin' do
         should contain_foreman__plugin('openscap')
      end
    end
  end
end
