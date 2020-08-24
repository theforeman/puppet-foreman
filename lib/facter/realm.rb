require_relative 'util/realm'
if defined? Facter::Util::Realm
  # == Fact: foreman_ipa
  Facter.add(:foreman_ipa, :type => :aggregate) do
    {
      :default_realm => 'global/realm',
      :default_server => 'global/server',
    }.each do |key, path|
      chunk(key) do
        val = Facter::Util::Realm.ipa_value(path)
        {key => val} if val
        # == Fact: foreman_sssd
      end
    end
  end
  Facter.add(:foreman_sssd, :type => :aggregate) do
    {
      :services => 'target[.="sssd"]/services',
      :server => 'target[.=~regexp("domain/.*")][1]/ipa_server',
      :ldap_user_extra_attrs => 'target[.=~regexp("domain/.*")][1]/ldap_user_extra_attrs',
      :allowed_uids => 'target[.="ifp"]/allowed_uids',
      :user_attributes => 'target[.="ifp"]/user_attributes',
    }.each do |key, path|
      chunk(key) do
        val = Facter::Util::Realm.sssd_value(path)
        {key => val} if val
      end
    end
  end
end
