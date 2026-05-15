module PuppetX
  module Foreman
    module Common

      # Parameters common to several types that use the rest_v3 api provider
      REST_API_COMMON_PARAMS = Proc.new do
        ensurable

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

        newparam(:ssl_ca) do
          desc 'Foreman SSL CA (certificate authority) for verification'
        end

        newparam(:timeout) do
          desc "Timeout for HTTP(s) requests"

          munge do |value|
            value = value.shift if value.is_a?(Array)
            begin
              value = Integer(value)
            rescue ArgumentError
              raise ArgumentError, "The timeout must be a number.", $!.backtrace
            end
            [value, 0].max
          end

          defaultto 500
        end

        autorequire(:anchor) do
          ['foreman::service','foreman::providers::oauth']
        end
      end

      FOREMAN_HOST_PARAMS = Proc.new do
        newparam(:name, :namevar => true) do
          desc 'The name of the resource.'
        end

        newparam(:hostname) do
          desc 'The name of the host.'
        end
      end

      FOREMAN_DOMAIN_PARAMS = Proc.new do
        newparam(:name, :namevar => true) do
          desc 'The name of the domain resource.'
        end

        newparam(:fullname) do
          desc 'The name/description of the domain.'
        end

        newparam(:dns_id) do
          desc 'DNS Smart Proxy ID.'
        end
      end

      FOREMAN_SUBNET_PARAMS = Proc.new do
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
    end
  end
end
