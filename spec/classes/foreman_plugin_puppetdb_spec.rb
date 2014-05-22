require 'spec_helper'

describe 'foreman::plugin::puppetdb' do
  let :facts do {
    :osfamily => 'Debian',
    :domain   => 'example.org',
  } end

  it 'should call the plugin' do
    should contain_foreman__plugin('puppetdb').with_package('ruby-puppetdb_foreman')
  end

  it 'should configure the plugin' do
    content = subject.resource('file', '/etc/foreman/settings.plugins.d/puppetdb.yaml').send(:parameters)[:content]
    content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
      '---',
      ':puppetdb:',
      '  :enabled: true',
      '  :address: "https://puppetdb.example.org:8081/v2/commands"',
    ]
  end
end
