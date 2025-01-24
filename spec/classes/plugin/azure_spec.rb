require 'spec_helper'

describe 'foreman::plugin::azure' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'azure_rm'
end
