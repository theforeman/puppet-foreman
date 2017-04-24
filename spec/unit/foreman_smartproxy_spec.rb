require 'spec_helper'

describe Puppet::Type.type(:foreman_smartproxy) do
  describe 'features' do
    it { expect(described_class.new(name: 's').property(:features).insync?([])).to eq(true) }
    it { expect(described_class.new(name: 's', features: ['Logs']).property(:features).insync?(['Logs'])).to eq(true) }
    it { expect(described_class.new(name: 's', features: ['Logs']).property(:features).insync?(['Logs', 'Other'])).to eq(true) }
    it { expect(described_class.new(name: 's', features: ['TFTP', 'Logs']).property(:features).insync?(['Logs', 'TFTP'])).to eq(true) }
    it { expect(described_class.new(name: 's', features: ['TFTP', 'Logs']).property(:features).insync?(['Logs'])).to eq(false) }
    it { expect(described_class.new(name: 's', features: ['TFTP', 'Logs']).property(:features).insync?([])).to eq(false) }
  end
end
