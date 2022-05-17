require 'spec_helper'

shared_examples 'generic namevar' do |name|
  it { expect(described_class.attrtype(name)).to eq :param }

  it 'is the namevar' do
    expect(described_class.key_attributes).to eq [name]
  end
end # generic namevar

shared_examples 'generic ensurable' do |*allowed|
  allowed ||= %i[present absent]

  context 'attrtype' do
    it { expect(described_class.attrtype(:ensure)).to eq :property }
  end

  context 'class' do
    it do
      expect(described_class.propertybyname(:ensure).ancestors)
        .to include(Puppet::Property::Ensure)
    end
  end

  it 'has no default value' do
    user = described_class.new(name: 'foo')
    expect(user.should(:ensure)).to be_nil
  end

  allowed.each do |value|
    it "should support #{value} as a value to :ensure" do
      expect { described_class.new(name: 'foo', ensure: value) }.not_to raise_error
    end
  end

  it 'rejects unknown values' do
    expect { described_class.new(name: 'foo', ensure: :foo) }.to raise_error(Puppet::Error)
  end
end # generic ensurable

shared_examples 'boolean property' do |param, default|
  it 'does not allow non-boolean values' do
    expect do
      described_class.new(:name => 'foo', param => 'unknown')
    end.to raise_error Puppet::ResourceError, /expected a boolean value/
  end

  it_behaves_like 'validated property', param, default, [true, false]
end # boolean property

shared_examples 'isrequired property' do |param|
  it 'is a isrequired property' do
    p = described_class.propertybyname(param)
    expect(p.required?).to eq true
  end
end # isrequired property

shared_examples 'validated property' do |param, default, allowed|
  context 'attrtype' do
    it { expect(described_class.attrtype(param)).to eq :property }
  end

  allowed.each do |value|
    it "should support #{value} as a value" do
      expect { described_class.new(:name => 'foo', param => value) }
        .not_to raise_error
    end
  end

  if default.nil?
    it 'has no default value' do
      resource = described_class.new(name: 'foo')
      expect(resource.should(param)).to be_nil
    end
  else
    it "should default to #{default}" do
      resource = described_class.new(name: 'foo')
      expect(resource.should(param)).to eq default
    end
  end

  it 'rejects unknown values' do
    expect { described_class.new(:name => 'foo', param => :foo) }
      .to raise_error(Puppet::Error)
  end
end # validated property

describe Puppet::Type.type(:foreman_global_parameter) do
  describe 'parameters' do
    describe 'name' do
      it_behaves_like 'generic namevar', :name
    end
  end # parameters

  describe 'properties' do
    describe 'ensure' do
      it_behaves_like 'generic ensurable'
    end

    describe 'hidden_value' do
      it_behaves_like 'boolean property', :hidden_value, nil
    end
  end
end
