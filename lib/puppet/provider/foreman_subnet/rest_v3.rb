Puppet::Type.type(:foreman_subnet).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_resource).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def exists?
    !id.nil?
  end

  def create
    path = "api/v2/subnets"
    payload = {
      :subnet => {
        :name => resource[:name],
        :description => resource[:description],
        :network_type => resource[:network_type],
        :network => resource[:network],
        :cidr => resource[:cidr],
        :mask => resource[:mask],
        :gateway => resource[:gateway],
        :dns_primary => resource[:dns_primary],
        :dns_secondary => resource[:dns_secondary],
        :ipam => !resource[:ipam].nil? ? resource[:ipam] : 'None',
        :from => resource[:from],
        :to => resource[:to],
        :vlanid => resource[:vlanid],
        :domain_ids => resource[:domain_ids].map {|s| search('domains', s)},
        :dhcp_id => search('smart_proxies', resource[:dhcp_id]),
        :tftp_id => search('smart_proxies', resource[:tftp_id]),
        :httpboot_id => search('smart_proxies', resource[:httpboot_id]),
        :dns_id => search('smart_proxies', resource[:dns_id]),
        :template_id => search('smart_proxies', resource[:template_id]),
        :bmc_id => search('smart_proxies', resource[:bmc_id]),
      }
    }

    req = request(:post, path, {}, payload.to_json)

    unless success?(req)
      error_string = "Error making POST request to Foreman at #{request_uri(path)}: #{error_message(req)}"
      raise Puppet::Error.new(error_string)
    end
  end

  def destroy
    req = request(:delete, destroy_path, {})

    unless success?(req)
      error_string = "Error making DELETE request to Foreman at #{request_uri(path)}: #{error_message(req)}"
      raise Puppet::Error.new(error_string)
    end
  end

  def id
    subnet['id'] if subnet
  end

  def subnet
    @subnet ||= begin
      path = 'api/v2/subnets'
      req = request(:get, path, :search => %{name="#{resource[:name]}"})

      unless success?(req)
        error_string = "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(req)}"
        raise Puppet::Error.new(error_string)
      end

      JSON.load(req.body)['results'].first
    end
  end

  private

  def destroy_path
    "api/v2/subnets/#{id}"
  end
end
