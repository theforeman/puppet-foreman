require 'spec_helper'

describe 'foreman::plugin::bootdisk' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'bootdisk'
end
