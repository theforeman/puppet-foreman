require 'spec_helper'

describe 'foreman::plugin::proxmox' do
  include_examples 'basic foreman plugin tests', 'fog_proxmox'
end
