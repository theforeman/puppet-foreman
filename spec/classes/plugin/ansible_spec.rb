require 'spec_helper'

describe 'foreman::plugin::ansible' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'ansible'
  it { should contain_foreman__plugin('tasks') }
end
