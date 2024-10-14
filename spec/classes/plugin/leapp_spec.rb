require 'spec_helper'

describe 'foreman::plugin::leapp' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'leapp'
  it { should contain_foreman__plugin('remote_execution') }
  it { should contain_foreman__plugin('ansible') }
end
