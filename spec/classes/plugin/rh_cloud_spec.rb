require 'spec_helper'

describe 'foreman::plugin::rh_cloud' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'rh_cloud'
end
