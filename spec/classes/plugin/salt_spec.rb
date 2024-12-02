require 'spec_helper'

describe 'foreman::plugin::salt' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'salt'
  it { should contain_foreman__plugin('tasks') }
end
