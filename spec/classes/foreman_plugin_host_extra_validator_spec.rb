require 'spec_helper'

describe 'foreman::plugin::host_extra_validator' do
  let(:facts) do
    on_supported_os['redhat-7-x86_64']
  end

  let(:pre_condition) { 'include foreman' }

  it { should contain_foreman__plugin('host_extra_validator') }
end
