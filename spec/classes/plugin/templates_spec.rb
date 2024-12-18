require 'spec_helper'

describe 'foreman::plugin::templates' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'templates'
end
