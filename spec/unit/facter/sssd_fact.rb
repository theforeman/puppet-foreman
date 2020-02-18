require 'spec_helper'

describe 'sssd' do
  subject { Facter.value(:sssd) }

  before do
    Facter.reset
    Facter.loadfacts
    allow(Facter::Util::Sssd).to receive(:sssd_value).with('target[.="sssd"]/services').and_return(services)
    allow(Facter::Util::Sssd).to receive(:sssd_value).with('target[.=~regexp("domain/.*")][1]/ldap_user_extra_attrs').and_return(ldap_user_extra_attrs)
    allow(Facter::Util::Sssd).to receive(:sssd_value).with('target[.="ifp"]/allowed_uids').and_return(allowed_uids)
    allow(Facter::Util::Sssd).to receive(:sssd_value).with('target[.="ifp"]/user_attributes').and_return(user_attributes)
  end

  let(:services) { nil }
  let(:ldap_user_extra_attrs) { nil }
  let(:allowed_uids) { nil }
  let(:user_attributes) { nil }

  context 'not enrolled' do
    it { is_expected.to be_nil }
  end

  context 'enrolled' do
    context 'services' do
      let(:services) { 'example' }

      it { is_expected.to eq({'services' => 'example'}) }
    end

    context 'ldap_user_extra_attrs' do
      let(:ldap_user_extra_attrs) { 'middlename:mid' }

      it { is_expected.to eq({'ldap_user_extra_attrs' => 'middlename:mid'}) }
    end

    context 'allowed_uids' do
      let(:allowed_uids) { 'joe' }

      it { is_expected.to eq({'allowed_uids' => 'joe'}) }
    end

    context 'user_attributes' do
      let(:user_attributes) { '+mid' }

      it { is_expected.to eq({'user_attributes' => '+mid'}) }
    end

    context 'services and allowed_uids' do
      let(:services) { 'example' }
      let(:allowed_uids) { 'joe' }

      it { is_expected.to eq({'services' => 'example', 'allowed_uids' => 'joe'}) }
    end
  end
end
