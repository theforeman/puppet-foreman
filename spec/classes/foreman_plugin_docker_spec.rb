require 'spec_helper'

describe 'foreman::plugin::docker' do
  let(:facts) do
    on_supported_os['redhat-7-x86_64']
  end

  it { should contain_foreman__plugin('docker') }
end
