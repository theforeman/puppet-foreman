require 'spec_helper'

describe 'foreman::to_symbolized_yaml' do
  it 'should exist' do
    is_expected.not_to eq(nil)
  end

  it 'should symbolize keys' do
    is_expected.to run.with_params({'a' => 'b'}).and_return("---\n:a: b\n")
  end
end
