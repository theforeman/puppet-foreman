require 'spec_helper'

supported = on_supported_os

['ansible', 'azure', 'discovery', 'kubevirt', 'openscap', 'remote_execution', 'tasks', 'templates', 'virt_who_configure'].each do |plugin|
  describe "foreman::cli::#{plugin}" do
    supported.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }
        let(:pre_condition) { 'include foreman::cli' }
        let(:plugin_name) { plugin == 'azure' ? 'foreman_azure_rm' : "foreman_#{plugin}" }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman__cli__plugin(plugin_name) }
      end
    end
  end
end
