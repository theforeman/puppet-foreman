require 'spec_helper'

describe 'foreman::plugin::wreckingball' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'wreckingball'
end
