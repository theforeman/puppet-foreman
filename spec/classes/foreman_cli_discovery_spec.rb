require 'spec_helper'

describe 'foreman::cli::discovery' do
  let(:pre_condition) { 'include foreman::cli' }

  context 'on redhat-7-x86_64' do
    let(:facts) { on_supported_os['redhat-7-x86_64'] }
    it { should contain_package('tfm-rubygem-hammer_cli_foreman_discovery') }
  end

  context 'on debian-9-x86_64' do
    let(:facts) { on_supported_os['debian-9-x86_64'] }
    it { should contain_package('ruby-hammer-cli-foreman-discovery') }
  end
end
