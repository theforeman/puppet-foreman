require 'spec_helper'

describe 'foreman' do
  it 'should exist' do
    expect(Puppet::Parser::Functions.function('foreman')).to eq 'function_foreman'
  end

  it 'should throw an error with no arguments' do
    is_expected.to run.with_params().and_raise_error(Puppet::ParseError)
  end

  # TODO: Test functionality of the actual function.

end
