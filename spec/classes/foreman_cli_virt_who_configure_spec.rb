require 'spec_helper'

describe 'foreman::cli::virt_who_configure' do
  let(:pre_condition) { 'include foreman::cli' }

  context 'on redhat-7-x86_64' do
    let(:facts) { on_supported_os['redhat-7-x86_64'] }
    it { should contain_package('tfm-rubygem-hammer_cli_foreman_virt_who_configure') }
  end

  context 'on debian-9-x86_64' do
    let(:facts) { on_supported_os['debian-9-x86_64'] }
    it { should contain_package('ruby-hammer-cli-foreman-virt-who-configure') }
  end
end
