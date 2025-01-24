require 'spec_helper'

describe 'foreman::plugin::puppet' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'puppet'
end
