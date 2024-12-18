require 'spec_helper'

describe 'foreman::plugin::kubevirt' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'kubevirt'
end
