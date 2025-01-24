require 'spec_helper'

describe 'foreman::plugin::scc_manager' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'scc_manager'
end
