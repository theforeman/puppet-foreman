require 'spec_helper'

describe 'ensure_value_in_string' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('ensure_value_in_string')).to eq 'function_ensure_value_in_string'
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
    expect(scope.function_ensure_value_in_string(['one,two', ['three']])).to eq 'one,two,three'
  end

  it 'should append values to the end in same order' do
    expect(scope.function_ensure_value_in_string(['one,two', ['three', 'four']])).to eq 'one,two,three,four'
  end

  it 'should not append values existing in original string' do
    expect(scope.function_ensure_value_in_string(['one,two', ['two', 'three']])).to eq 'one,two,three'
    expect(scope.function_ensure_value_in_string(['one,two', ['one', 'three']])).to eq 'one,two,three'
    expect(scope.function_ensure_value_in_string(['one,two', ['one', 'two']])).to eq 'one,two'
  end

  it 'should append even to empty strings' do
    expect(scope.function_ensure_value_in_string(['', ['two', 'three']])).to eq 'two,three'
  end

  it 'should append even empty array' do
    expect(scope.function_ensure_value_in_string(['one,two', []])).to eq 'one,two'
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
    expect(scope.function_ensure_value_in_string(['one, two,   three    ,    four', ['five']])).to eq 'one, two,   three    ,    four,five'
  end

  it 'should accept third argument as a custom separator' do
    expect(scope.function_ensure_value_in_string(['one,two', ['two', 'three'], ', '])).to eq 'one,two, three'
  end
end
