# == Fact: default_ipa_realm
# == Fact: default_ipa_server
# == Fact: sssd_services
# == Fact: sssd_ldap_user_extra_attrs
# == Fact: sssd_allowed_uids
# == Fact: sssd_user_attributes
#
require 'augeas'
Facter.add(:default_ipa_realm) do
  setcode do
    Augeas::open('/', nil, Augeas::NO_MODL_AUTOLOAD) do |aug|
      aug.transform(:lens => "Puppet.lns", :incl => "/etc/ipa/default.conf")
      aug.load
      aug.get("/files/etc/ipa/default.conf/global/realm")
    end
  end
end
Facter.add(:default_ipa_server) do
  setcode do
    Augeas::open('/', nil, Augeas::NO_MODL_AUTOLOAD) do |aug|
      aug.transform(:lens => "Puppet.lns", :incl => "/etc/ipa/default.conf")
      aug.load
      aug.get("/files/etc/ipa/default.conf/global/server")
    end
  end
end
Facter.add(:sssd_services) do
  setcode do
    Augeas::open do |aug|
      aug.get("/files/etc/sssd/sssd.conf/target[.='sssd']/services")
    end
  end
end
Facter.add(:sssd_ldap_user_extra_attrs) do
  setcode do
    Augeas::open do |aug|
      aug.get("/files/etc/sssd/sssd.conf/target[.=~regexp('domain/.*')][1]/ldap_user_extra_attrs")
    end
  end
end
Facter.add(:sssd_allowed_uids) do
  setcode do
    Augeas::open do |aug|
      aug.get("/files/etc/sssd/sssd.conf/target[.='ifp']/allowed_uids")
    end
  end
end
Facter.add(:sssd_user_attributes) do
  setcode do
    Augeas::open do |aug|
      aug.get("/files/etc/sssd/sssd.conf/target[.='ifp']/user_attributes")
    end
  end
end
