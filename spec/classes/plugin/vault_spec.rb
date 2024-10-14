require 'spec_helper'

describe 'foreman::plugin::vault' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'vault'
end
