require 'spec_helper'
require 'uri'
require 'net/http'

describe 'smartvar' do
  let(:facts) { { 'hardwaremodel' => 'x86_64'} }
  let(:node) { 'test.example.com' }
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('smartvar')).to eq 'function_smartvar'
  end

  it 'should throw an error with no arguments' do
    expect(lambda {
      scope.function_smartvar([])
    }).to raise_error(Puppet::ParseError)
  end

  # TODO: Test functionality of the actual function.

end
