require 'spec_helper'

describe 'foreman::plugin::dlm' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'dlm'
end
