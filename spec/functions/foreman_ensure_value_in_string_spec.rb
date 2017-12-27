require 'spec_helper'

describe 'foreman::ensure_value_in_string' do
  it 'should exist' do
    is_expected.not_to eq(nil)
  end

  it 'should throw an error with bad number of arguments' do
    is_expected.to run.with_params().and_raise_error(ArgumentError)
    is_expected.to run.with_params('string').and_raise_error(ArgumentError)
    is_expected.to run.with_params('string', [], ', ', 'additional').and_raise_error(ArgumentError)
  end

  it 'should append values to the end' do
    is_expected.to run.with_params('one,two', ['three']).and_return('one,two,three')
  end

  it 'should append values to the end in same order' do
    is_expected.to run.with_params('one,two', ['three', 'four']).and_return('one,two,three,four')
  end

  it 'should not append values existing in original string' do
    is_expected.to run.with_params('one,two', ['two', 'three']).and_return('one,two,three')
    is_expected.to run.with_params('one,two', ['one', 'three']).and_return('one,two,three')
    is_expected.to run.with_params('one,two', ['one', 'two']).and_return('one,two')
  end

  it 'should append even to empty strings' do
    is_expected.to run.with_params('', ['two', 'three']).and_return('two,three')
  end

  it 'should append even empty array' do
    is_expected.to run.with_params('one,two', []).and_return('one,two')
  end

  it 'should not allow using wrong types and undefined values' do
    is_expected.to run.with_params(nil, ['two', 'three']).and_raise_error(ArgumentError)
    is_expected.to run.with_params(:undef, ['two', 'three']).and_raise_error(ArgumentError)
    is_expected.to run.with_params('one', 'two').and_raise_error(ArgumentError)
  end

  it 'should ignore whitespaces but preserve it' do
    is_expected.to run.with_params('one, two,   three    ,    four', ['five']).and_return('one, two,   three    ,    four,five')
  end

  it 'should accept third argument as a custom separator' do
    is_expected.to run.with_params('one,two', ['two', 'three'], ', ').and_return('one,two, three')
  end
end
