require 'spec_helper'

describe 'foreman::plugin::memcache' do

  it 'should call the plugin' do
    should contain_foreman__plugin('memcache')
  end
end
