require 'spec_helper'

describe 'foreman::plugin::hdm' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'hdm'
end
