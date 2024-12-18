require 'spec_helper'

describe 'foreman::plugin::statistics' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'statistics'
end
