require 'spec_helper'

supported = on_supported_os

['ansible', 'azure', 'discovery', 'katello', 'kubevirt', 'openscap', 'remote_execution', 'ssh', 'tasks', 'templates', 'virt_who_configure', 'webhooks', 'puppet', 'google', 'rh_cloud'].each do |plugin|
  describe "foreman::cli::#{plugin}" do
    supported.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }
        let(:pre_condition) { 'include foreman::cli' }
        let(:plugin_name) do
          case plugin
          when 'azure'
            'foreman_azure_rm'
          when 'katello'
            'katello'
          else
            "foreman_#{plugin}"
          end
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman__cli__plugin(plugin_name) }
      end
    end
  end
end
