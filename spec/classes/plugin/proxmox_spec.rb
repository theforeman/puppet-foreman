require 'spec_helper'

describe 'foreman::plugin::proxmox' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'fog_proxmox'
end
