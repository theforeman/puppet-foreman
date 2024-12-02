require 'spec_helper'

describe 'foreman::plugin::rescue' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'rescue'
end
