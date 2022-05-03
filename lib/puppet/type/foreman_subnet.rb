require_relative '../../puppet_x/foreman/common'

Puppet::Type.newtype(:foreman_subnet) do
  desc 'foreman_subnet creates a subnet in foreman.'

  instance_eval(&PuppetX::Foreman::Common::REST_API_COMMON_PARAMS)

  newparam(:name, :namevar => true) do
    desc 'The name of the subnet resource.'
  end

  newparam(:description) do
    desc 'The subnet description.'
  end

  newparam(:network_type) do
    desc 'The subnet network type, either "IPv4" or "IPv6".'
  end

  newparam(:network) do
    desc 'The subnet network address.'
  end

  newparam(:cidr) do
    desc 'The subnet network CIDR.'
  end

  newparam(:mask) do
    desc 'The subnet network mask.'
  end

  newparam(:gateway) do
    desc 'The subnet gateway.'
  end

  newparam(:dns_primary) do
    desc 'Primary DNS address.'
  end

  newparam(:dns_secondary) do
    desc 'Secondary DNS address.'
  end

  newparam(:ipam) do
    desc 'IPAM Source type.'
  end

  newparam(:to) do
    desc 'Static IPAM end address.'
  end

  newparam(:from) do
    desc 'Static IPAM start address.'
  end

  newparam(:vlanid) do
    desc 'VLAN ID for this subnet.'
  end

  newparam(:domain_ids) do
    desc 'Domain IDs or searches to attribute to subnet.'
  end

  newparam(:dhcp_id) do
    desc 'DHCP Smart Proxy ID.'
  end

  newparam(:tftp_id) do
    desc 'TFTP Smart Proxy ID.'
  end

  newparam(:httpboot_id) do
    desc 'HTTP Boot Smart Proxy ID.'
  end

  newparam(:dns_id) do
    desc 'DNS Smart Proxy ID.'
  end

  newparam(:template_id) do
    desc 'Template Smart Proxy ID.'
  end

  newparam(:bmc_id) do
    desc 'BMC Smart Proxy ID.'
  end
end
