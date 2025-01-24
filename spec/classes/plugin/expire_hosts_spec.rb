require 'spec_helper'

describe 'foreman::plugin::expire_hosts' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'expire_hosts'
end
