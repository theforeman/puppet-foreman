Puppet::Type.newtype(:foreman_smartproxy) do
  desc 'foreman_smartproxy creates a smartproxy in foreman database.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the smartproxy.'
  end

  newproperty(:url) do
    desc 'The url of the smartproxy'
    newvalues(/^https?:\/\/[A-z0-9]+(-[A-z0-9]+)*(\.[A-z0-9]+(-[A-z0-9]+)*)*(:[0-9]+)*$/)
  end

end

