require 'spec_helper'

describe 'foreman::plugin::discovery' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'discovery'
end
