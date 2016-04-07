require 'spec_helper'

describe 'foreman::plugin::openscap' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let :facts do
        facts
      end

      it 'should call the plugin' do
         should contain_foreman__plugin('openscap')
      end
    end
  end
end
