require 'facter/util/sssd'

if defined? Facter::Util::Sssd
  # == Fact: ipa
  Facter.add(:ipa, :type => :aggregate) do
    {
      :default_realm => 'global/realm',
      :default_server => 'global/server',
    }.each do |key, path|
      chunk(key) do
        val = Facter::Util::Sssd.ipa_value(path)
        {key => val} if val
      end
    end
  end

  # == Fact: sssd
  Facter.add(:sssd, :type => :aggregate) do
    {
      :services => 'target[.="sssd"]/services',
      :ldap_user_extra_attrs => 'target[.=~regexp("domain/.*")][1]/ldap_user_extra_attrs',
      :allowed_uids => 'target[.="ifp"]/allowed_uids',
      :user_attributes => 'target[.="ifp"]/user_attributes',
    }.each do |key, path|
      chunk(key) do
        val = Facter::Util::Sssd.sssd_value(path)
        {key => val} if val
      end
    end

  end
end
