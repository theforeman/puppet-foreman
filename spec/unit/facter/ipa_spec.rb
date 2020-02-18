require 'spec_helper'

describe 'ipa' do
  subject { Facter.value(:ipa) }

  before do
    Facter.reset
    Facter.loadfacts
    allow(Facter::Util::Sssd).to receive(:ipa_value).with('global/realm').and_return(default_realm)
    allow(Facter::Util::Sssd).to receive(:ipa_value).with('global/server').and_return(default_server)
  end

  let(:default_realm) { nil }
  let(:default_server) { nil }

  context 'not enrolled' do
    it { is_expected.to be_nil }
  end

  context 'enrolled' do
    context 'default realm' do
      let(:default_realm) { 'EXAMPLE.COM' }

      it { is_expected.to eq({'default_realm' => 'EXAMPLE.COM'}) }
    end

    context 'default server' do
      let(:default_server) { 'ipa.example.com' }

      it { is_expected.to eq({'default_server' => 'ipa.example.com'}) }
    end

    context 'default server and realm' do
      let(:default_server) { 'ipa.example.com' }
      let(:default_realm) { 'EXAMPLE.COM' }

      it { is_expected.to eq({'default_server' => 'ipa.example.com', 'default_realm' => 'EXAMPLE.COM'}) }
    end
  end
end
