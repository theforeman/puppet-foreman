require 'spec_helper'

describe 'foreman::plugin::google' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'google'
end
