Puppet::Type.newtype(:foreman_user) do
  desc 'foreman_user creates a user in foreman database.'

  ensurable

  def munge_boolean(value)
    case value
    when true, "true", :true
      :true
    when false, "false", :false
      :false                                                                                
    else
      fail("munge_boolean only takes booleans")                                             
    end
  end 

  newparam(:login, :namevar => true) do
    desc 'The Login to user to connect to foreman.'

    newvalues(/^[0-9A-Za-z_]+$/)
  end

  newparam(:password) do
    desc 'Password to use at user creation.'

    defaultto 'changeme'
  end

  newproperty(:admin) do
    desc 'Wether user should be admin or not.'

    defaultto :false
    newvalues(:true, :false)

    munge do |value|                                                                        
      @resource.munge_boolean(value)                                                        
    end
  end

  newproperty(:firstname) do
    desc 'User\'s first name'
  end

  newproperty(:lastname) do
    desc 'User\'s last name'
  end

  newproperty(:mail) do
    desc 'User\'s mail'

    newvalues(/^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*(\.[A-Za-z]{2,4})$/)
  end

end
