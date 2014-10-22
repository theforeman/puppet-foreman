Puppet::Type.newtype(:foreman_config_entry) do

  desc 'foreman_config_entry set a foreman parameter'

  newparam(:name) do
    desc 'The name of the parameter.'
  end

  newproperty(:value) do
    desc 'The value of the parameter.'
  end

end
