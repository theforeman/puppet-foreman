require 'spec_helper'

describe 'foreman::plugin::virt_who_configure' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'virt_who_configure'
end
