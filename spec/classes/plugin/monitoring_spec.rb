require 'spec_helper'

describe 'foreman::plugin::monitoring' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'monitoring'
end
