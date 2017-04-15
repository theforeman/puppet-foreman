Puppet::Type.newtype(:foreman_subnet) do
  desc 'foreman_subnet registers a subnet in foreman.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the subnet.'
  end

  newparam(:base_url) do
    desc 'Foreman\'s base url.'
  end

  newparam(:effective_user) do
    desc 'Foreman\'s effective user for the registration (usually admin).'
  end

  newparam(:consumer_key) do
    desc 'Foreman oauth consumer_key'
  end

  newparam(:consumer_secret) do
    desc 'Foreman oauth consumer_secret'
  end

  newproperty(:network) do
    desc 'The network address for this subnet'
    isrequired
  end

  newproperty(:netmask) do
    desc 'The netmask for this subnet'
    isrequired
  end

  newproperty(:gateway) do
    desc 'The subnet gateway'
  end

  newproperty(:dns_primary) do
    desc 'The primary DNS for this subnet'
  end

  newproperty(:dns_secondary) do
    desc 'The secondary DNS for this subnet'
  end

  newproperty(:from) do
    desc 'Starting IP Address for IP auto suggestion'
  end

  newproperty(:to) do
    desc 'Ending IP Address for IP auto suggestion'
  end

  newproperty(:vlan) do
    desc 'The VLAN number for this subnet'
  end

  newproperty(:domains, :array_matching => :all) do
    desc 'The domains that are allowed on this subnet'
  end

  newproperty(:dhcp_proxy) do
    desc 'The DHCP proxy that serves this subnet. Must be a foreman_smartproxy.'
  end

  newproperty(:tftp_proxy) do
    desc 'The TFTP proxy that serves this subnet. Must be a foreman_smartproxy.'
  end

  newproperty(:dns_proxy) do
    desc 'The DNS proxy that serves the reverse DNS for this subnet. Must be a foreman_smartproxy.'
  end

  autorequire(:foreman_smartproxy) do
    reqs = []

    # FIXME
    reqs << @parameters[:dhcp_proxy] if @parameters[:dhcp_proxy]
    reqs << @parameters[:tftp_proxy] if @parameters[:tftp_proxy]
    reqs << @parameters[:dns_proxy] if @parameters[:dns_proxy]

    reqs
  end

end
