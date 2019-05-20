require 'spec_helper'

describe 'foreman::cli::kubevirt' do
  let(:facts) do
    on_supported_os['redhat-7-x86_64']
  end

  let(:pre_condition) { 'include foreman::cli' }

  it { should contain_package('tfm-rubygem-hammer_cli_foreman_kubevirt') }
end
