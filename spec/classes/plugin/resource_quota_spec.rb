require 'spec_helper'
describe 'foreman::plugin::resource_quota' do
  include_examples 'basic foreman plugin tests', 'resource_quota'
  it { should contain_foreman__plugin('tasks') }
end
