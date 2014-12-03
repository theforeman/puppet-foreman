require 'spec_helper'

describe 'foreman::plugin::puppetdb' do
  let :facts do {
    :osfamily => 'Debian',
  } end

  it 'should call the plugin' do
    should contain_foreman__plugin('puppetdb').with_package('ruby-puppetdb-foreman')
  end
end
