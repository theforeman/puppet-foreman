require 'spec_helper'

describe 'foreman::smartvar' do
  it 'should exist' do
    is_expected.not_to eq(nil)
  end

  it 'should throw an error with no arguments' do
    is_expected.to run.with_params().and_raise_error(ArgumentError)
  end

  # TODO: Test functionality of the actual function.

end
