require 'spec_helper'

describe 'foreman' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_class('foreman::install') }
      it { should contain_class('foreman::config') }
      it { should contain_class('foreman::database') }
      it { should contain_class('foreman::service') }
    end
  end
end
