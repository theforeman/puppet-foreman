require 'spec_helper'

describe 'foreman::cli::remote_execution' do
  let(:pre_condition) { 'include foreman::cli' }

  context 'on redhat-7-x86_64' do
    let(:facts) { on_supported_os['redhat-7-x86_64'] }
    it { should contain_package('tfm-rubygem-hammer_cli_foreman_remote_execution') }
  end
end
