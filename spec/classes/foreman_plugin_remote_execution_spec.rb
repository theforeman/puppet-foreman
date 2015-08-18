require 'spec_helper'

describe 'foreman::plugin::remote_execution' do
  on_supported_os.each do |_os, facts|
    let(:facts) { facts }
    it { should contain_foreman__plugin('remote_execution') }
  end
end
