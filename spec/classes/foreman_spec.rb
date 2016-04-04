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

      it { should contain_class('foreman::repo').that_notifies('Class[foreman::install]') }
      it { should contain_class('foreman::install') }
      it { should contain_class('foreman::config') }
      it { should contain_class('foreman::database') }
      it { should contain_class('foreman::service') }

      describe 'with foreman::cli' do
        let :pre_condition do
          "class { 'foreman': }
           class { 'foreman::cli': }"
        end

        it { is_expected.to compile.with_all_deps }
        it { should contain_package('foreman-cli').that_subscribes_to('Class[foreman::repo]') }
      end

      describe 'with foreman::providers' do
        let :pre_condition do
          "class { 'foreman': }
           class { 'foreman::providers':
             apipie_bindings_package => 'apipie-bindings',
           }"
        end

        it { is_expected.to compile.with_all_deps }
        it { should contain_package('apipie-bindings').that_subscribes_to('Class[foreman::repo]') }
      end
    end
  end
end
