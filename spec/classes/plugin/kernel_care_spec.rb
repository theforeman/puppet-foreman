require 'spec_helper'

describe 'foreman::plugin::kernel_care' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'kernel_care'
end
