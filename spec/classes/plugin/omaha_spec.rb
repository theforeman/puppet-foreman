require 'spec_helper'

describe 'foreman::plugin::omaha' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'omaha'
end
