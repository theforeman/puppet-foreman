require 'spec_helper'

describe 'foreman::plugin::discovery' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include foreman' }

      it { should contain_foreman__plugin('discovery') }
    end
  end
end
