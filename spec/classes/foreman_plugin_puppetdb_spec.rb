require 'spec_helper'

describe 'foreman::plugin::puppetdb' do
  let :facts do {
    :osfamily => 'Debian',
    :domain   => 'example.org',
  } end

  let :params do {
    :enabled => true,
    :address => 'https://puppetdb.example.org:8081/v2/commands',
  } end

  it 'should call the plugin' do
    should contain_foreman__plugin('puppetdb').with_package('ruby-puppetdb-foreman')
  end

  it 'should configure the plugin' do
    content = catalogue.resource('file', '/etc/foreman/plugins/puppetdb.yaml').send(:parameters)[:content]
    content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
      '---',
      ':puppetdb:',
      '  :puppetdb_enabled: true',
      '  :puppetdb_address: "https://puppetdb.example.org:8081/v2/commands"',
    ]
  end
end
