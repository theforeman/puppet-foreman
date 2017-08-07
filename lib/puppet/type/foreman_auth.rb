require 'puppet/property/boolean'

Puppet::Type.newtype(:foreman_auth) do
  @doc = 'foreman_auth manages LDAP authentication sources in foreman.'
  ensurable

  newproperty(:account) do
    desc 'Bind account name for browsing LDAP directory.'
  end

  newproperty(:account_password) do
    desc 'Bind account password for browsing LDAP directory.'

    def change_to_s(currentvalue, newvalue)
      return _('[redacted]')
    end
    def is_to_s( currentvalue )
      return _('[redacted]')
    end
    def should_to_s( newvalue )
      return _('[redacted]')
    end
  end

  newproperty(:attr_firstname) do
    desc ''
  end

  newproperty(:attr_lastname) do
    desc ''
  end

  newproperty(:attr_login) do
    desc ''
  end

  newproperty(:attr_mail) do
    desc ''
  end

  newproperty(:attr_photo) do
    desc ''
  end

  newproperty(:base_dn) do
    desc 'Top level DN of your LDAP directory tree'
  end

  newparam(:base_url) do
    desc 'Foreman\'s base url.'
  end

  newparam(:consumer_key) do
    desc 'Foreman oauth consumer_key'
  end

  newparam(:consumer_secret) do
    desc 'Foreman oauth consumer_secret'
  end

  newparam(:effective_user) do
    desc 'Foreman\'s effective user for the registration (usually admin).'
    defaultto 'admin'
  end

  newproperty(:host) do
    desc 'LDAP server hostname'
  end

  newproperty(:groups_base) do
    desc 'LDAP server hostname'
  end

  newparam(:name, namevar: :true) do
    desc 'Name of the LDAP authentication source.'
  end

  newproperty(:onthefly_register, :parent => Puppet::Property::Boolean) do
    desc 'Automatically create accounts in Foreman.'
  end

  newproperty(:port) do
    desc 'LDAP listening port, usually 389 or 636.'
  end

  newproperty(:server_type) do
    desc 'LDAP Server type, Active Directory, FreeIPA or POSIX.'
    defaultto 'POSIX'
    newvalues('Active Directory', 'FreeIPA', 'POSIX')
  end

  newparam(:ssl_ca) do
    desc 'Foreman SSL CA (certificate authority) for verification'
  end

  newparam(:timeout) do
    desc 'Timeout for http(s) requests'

    munge do |value|
      value = value.shift if value.is_a?(Array)
      begin
        value = Integer(value)
      rescue ArgumentError
        raise ArgumentError, 'timeout must be a number.', $!.backtrace
      end
      [value, 0].max
    end

    defaultto 500
  end

  newproperty(:tls, :parent => Puppet::Property::Boolean) do
    desc 'Enable LDAPS.'
  end
end

