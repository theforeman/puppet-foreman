require 'spec_helper'

describe Puppet::Type.type(:foreman_auth) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before :each do
        Facter.clear
        facts.each do |k, v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
        end
      end

      describe 'when validating attributes' do
        %i[
          base_url
          consumer_key
          consumer_secret
          effective_user
          name
          ssl_ca
          timeout
        ].each do |param|
          it "should have a #{param} parameter" do
            expect(described_class.attrtype(param)).to eq(:param)
          end
        end
        %i[
          account
          account_password
          attr_firstname
          attr_lastname
          attr_login
          attr_mail
          attr_photo
          base_dn
          host
          groups_base
          onthefly_register
          port
          server_type
        ].each do |prop|
          it "should have a #{prop} property" do
            expect(described_class.attrtype(prop)).to eq(:property)
          end
        end
        describe 'ensure' do
          %i[present absent].each do |value|
            it "should support #{value} as a value to ensure" do
              expect do
                described_class.new(
                  name:  'My LDAP Source',
                  ensure: value
                )
              end.to_not raise_error
            end
          end
          it 'should not support other values' do
            expect do
              described_class.new(
                name: 'My LDAP Source',
                ensure: 'bad'
              )
            end.to raise_error(Puppet::Error, /Invalid value/)
          end
        end # describe 'ensure'
        describe 'server_type' do
          ['Active Directory', 'FreeIPA', 'POSIX'].each do |server_type|
            it "should support '#{server_type}' as a value for server_type" do
              expect do
                described_class.new(
                  name:       'My LDAP Source',
                  server_type: server_type
                )
              end.to_not raise_error
            end
          end

          it 'should default to POSIX' do
            expect do
              described_class.new(
                name: 'My LDAP Source'
              )[:server_type].to eq :POSIX
            end
          end

          it 'should not support other values' do
            expect do
              described_class.new(
                name:        'My LDAP Source',
                server_type: 'bad'
              )
            end.to raise_error(Puppet::Error, /Invalid value/)
          end
        end # describe 'server_type'

        describe 'onthefly_register' do
          [:false, false, 'false', 'no'].each do |onthefly_register|
            it "should support '#{onthefly_register}' as a value for onthefly_register" do
              expect do
                described_class.new(
                  name:             'My LDAP Source',
                  onthefly_register: onthefly_register
                )[:onthefly_register].to eq :false
              end
            end
          end
          [:true, true, 'true', 'yes'].each do |onthefly_register|
            it "should support '#{onthefly_register}' as a value for onthefly_register" do
              expect do
                described_class.new(
                  name:             'My LDAP Source',
                  onthefly_register: onthefly_register
                )[:onthefly_register].to eq :true
              end
            end
          end
          it 'should default to false' do
            expect do
              described_class.new(
                name: 'My LDAP Source'
              )[:onthefly_register].to eq :false
            end
          end
        end # describe 'onthefly_register'

        describe 'tls' do
          [:false, false, 'false', 'no'].each do |tls|
            it "should support '#{tls}' as a value for tls" do
              expect do
                described_class.new(
                  name:             'My LDAP Source',
                  tls: tls
                )[:tls].to eq :false
              end
            end
          end
          [:true, true, 'true', 'yes'].each do |tls|
            it "should support '#{tls}' as a value for tls" do
              expect do
                described_class.new(
                  name:             'My LDAP Source',
                  tls: tls
                )[:tls].to eq :true
              end
            end
          end
          it 'should default to false' do
            expect do
              described_class.new(
                name: 'My LDAP Source'
              )[:tls].to eq :false
            end
          end
        end # describe 'tls'
      end # describe 'when validating attributes'
      describe 'namevar validation' do
        it 'should have :name as its namevar' do
          expect(described_class.key_attributes).to eq([:name])
        end
      end # describe 'namevar validation'
    end # context "on #{os}"
  end
end
