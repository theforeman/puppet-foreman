require 'spec_helper'

describe 'ensure_value_in_string' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    Puppet::Parser::Functions.function('ensure_value_in_string').should == 'function_ensure_value_in_string'
  end

  it 'should throw an error with bad number of arguments' do
    expect {
      scope.function_ensure_value_in_string([])
    }.to raise_error(Puppet::ParseError)

    expect {
      scope.function_ensure_value_in_string(['string'])
    }.to raise_error(Puppet::ParseError)

    expect {
      scope.function_ensure_value_in_string(['string', [], ', ', 'additional'])
    }.to raise_error(Puppet::ParseError)
  end

  it 'should append values to the end' do
    scope.function_ensure_value_in_string(['one,two', ['three']]).should eq('one,two,three')
  end

  it 'should append values to the end in same order' do
    scope.function_ensure_value_in_string(['one,two', ['three', 'four']]).should eq('one,two,three,four')
  end

  it 'should not append values existing in original string' do
    scope.function_ensure_value_in_string(['one,two', ['two', 'three']]).should eq('one,two,three')
    scope.function_ensure_value_in_string(['one,two', ['one', 'three']]).should eq('one,two,three')
    scope.function_ensure_value_in_string(['one,two', ['one', 'two']]).should eq('one,two')
  end

  it 'should append even to empty strings' do
    scope.function_ensure_value_in_string(['', ['two', 'three']]).should eq('two,three')
  end

  it 'should append even empty array' do
    scope.function_ensure_value_in_string(['one,two', []]).should eq('one,two')
  end

  it 'should not allow using wrong types and undefined values' do
    expect {
      scope.function_ensure_value_in_string([nil, ['two', 'three']])
    }.to raise_error(Puppet::ParseError)

    expect {
      scope.function_ensure_value_in_string([:undef, ['two', 'three']])
    }.to raise_error(Puppet::ParseError)

    expect {
      scope.function_ensure_value_in_string(['one', 'two'])
    }.to raise_error(Puppet::ParseError)
  end

  it 'should ignore whitespaces but preserve it' do
    scope.function_ensure_value_in_string(['one, two,   three    ,    four', ['five']]).should eq('one, two,   three    ,    four,five')
  end

  it 'should accept third argument as a custom separator' do
    scope.function_ensure_value_in_string(['one,two', ['two', 'three'], ', ']).should eq('one,two, three')
  end
end
