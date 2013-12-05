require 'spec_helper'

describe 'foreman::plugin::templates' do
  it 'should call the plugin' do
    should contain_foreman__plugin('templates')
  end
end
