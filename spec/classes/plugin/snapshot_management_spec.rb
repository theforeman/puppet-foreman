require 'spec_helper'

describe 'foreman::plugin::snapshot_management' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'snapshot_management'
end
