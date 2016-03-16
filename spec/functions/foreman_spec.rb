require 'spec_helper'

describe 'foreman' do
  let(:facts) { { 'hardwaremodel' => 'x86_64'} }
  let(:node) { 'test.example.com' }
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('foreman')).to eq 'function_foreman'
  end

  it 'should throw an error with no arguments' do
    expect(lambda {
      scope.function_foreman([])
    }). to raise_error(Puppet::ParseError)
  end

  # TODO: Test functionality of the actual function.

end
