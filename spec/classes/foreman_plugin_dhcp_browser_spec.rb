require 'spec_helper'

describe 'foreman::plugin::dhcp_browser' do
  let(:facts) do
    on_supported_os['redhat-7-x86_64']
  end

  it { should contain_foreman__plugin('dhcp_browser') }
end
