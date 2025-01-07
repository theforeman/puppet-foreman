require 'spec_helper'

describe 'foreman::plugin::datacenter' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'datacenter'
end
