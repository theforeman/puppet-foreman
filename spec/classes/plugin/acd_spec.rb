require 'spec_helper'

describe 'foreman::plugin::acd' do
  include_examples 'basic foreman plugin tests', 'acd'
  it { should contain_foreman__plugin('tasks') }
  it { should contain_foreman__plugin('remote_execution') }
end
