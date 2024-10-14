require 'spec_helper'

describe 'foreman::plugin::netbox' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'netbox'
end
