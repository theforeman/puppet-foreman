require 'spec_helper'

describe 'foreman::cli::virt_who_configure' do
  context 'on redhat-7-x86_64' do
    let(:facts) do
      on_supported_os['redhat-7-x86_64']
    end

    let(:pre_condition) { 'include foreman::cli' }

    it { should contain_package('tfm-rubygem-hammer_cli_foreman_virt_who_configure') }
  end

  context 'on debian-9-x86_64' do
    let(:facts) do
      on_supported_os['debian-9-x86_64']
    end

    let(:pre_condition) { 'include foreman::cli' }

    it { should contain_package('ruby-hammer-cli-foreman-virt-who-configure') }
  end
end
