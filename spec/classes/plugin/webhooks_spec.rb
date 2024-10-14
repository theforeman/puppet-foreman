require 'spec_helper'

describe 'foreman::plugin::webhooks' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'webhooks'
end
