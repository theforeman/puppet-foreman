Puppet::Type.type(:foreman_subnet).provide(:rest) do

  confine :feature => :foreman_api

  def subnets
    ForemanApi::Resources::Subnet.new({
      :base_url => resource[:base_url],
      :oauth    => {
        :consumer_key    => resource[:consumer_key],
        :consumer_secret => resource[:consumer_secret]
      }
    }, {
      :headers => {
        :foreman_user => resource[:effective_user]
      }
    })
  end

  def subnet
    if @subnet
      @subnet
    else
      spi = subnets.index[0]
      if spi.is_a?(Hash) && spi.has_key?('results')
        # foreman_api 0.1.18+
        @subnet = spi['results'].find { |s| s['name'] == resource[:name] }
      else
        # foreman_api < 0.1.18
        @subnet = spi.find { |s| s['subnet']['name'] == resource[:name] }['subnet']
      end
    end
  end

  def id
    subnet ? subnet['id'] : nil
  end

  def exists?
    !!subnet
  end

  def create
    subnets.create({
      'subnet' => {
        'name' => resource[:name],
        'network' => resource[:network],
        'mask' => resource[:netmask],
        'gateway' => resource[:gateway],
        'dns_primary' => resource[:dns_primary],
        'dns_secondary' => resource[:dns_secondary],
        'from' => resource[:from],
        'to' => resource[:to],
        'vlanid' => resource[:vlan],
        'dns_id' => smartproxy_id(resource[:dns_proxy]),
        'dhcp_id' => smartproxy_id(resource[:dhcp_proxy]),
        'tftp_id' => smartproxy_id(resource[:tftp_proxy]),
      }
    })
  end

  #def flush
  #  subnets.update({
  #    'id' => @property_hash[:id],
  #    'subnet' => {
  #      'name' => @property_hash[:name],
  #      'network' => @property_hash[:network],
  #      'mask' => @property_hash[:netmask],
  #      'gateway' => @property_hash[:gateway],
  #      'dns_primary' => @property_hash[:dns_primary],
  #      'dns_secondary' => @property_hash[:dns_secondary],
  #      'from' => @property_hash[:from],
  #      'to' => @property_hash[:to],
  #      'vlanid' => @property_hash[:vlan],
  #      'dns_id' => @property_hash[:dns_proxy],
  #      'dhcp_id' => @property_hash[:dhcp_proxy],
  #      'tftp_id' => @property_hash[:tftp_proxy],
  #    }
  #  })
  #end

  def destroy
    subnets.destroy({'id' => id})
    @subnet = nil
  end

  def network
    subnet ? subnet['network'] : nil
  end

  def network=(value)
    subnets.update({'id' => id, 'subnet' => {'network' => value}})
  end

  def netmask
    subnet ? subnet['mask'] : nil
  end

  def netmask=(value)
    subnets.update({'id' => id, 'subnet' => {'mask' => value}})
  end

  def gateway
    subnet ? subnet['gateway'] : nil
  end

  def gateway=(value)
    subnets.update({'id' => id, 'subnet' => {'gateway' => value}})
  end

  def dns_primary
    subnet ? subnet['dns_primary'] : nil
  end

  def dns_primary=(value)
    subnets.update({'id' => id, 'subnet' => {'dns_primary' => value}})
  end

  def dns_secondary
    subnet ? subnet['dns_secondary'] : nil
  end

  def dns_secondary=(value)
    subnets.update({'id' => id, 'subnet' => {'dns_secondary' => value}})
  end

  def from
    subnet ? subnet['from'] : nil
  end

  def from=(value)
    subnets.update({'id' => id, 'subnet' => {'from' => value}})
  end

  def to
    subnet ? subnet['to'] : nil
  end

  def to=(value)
    subnets.update({'id' => id, 'subnet' => {'to' => value}})
  end

  def vlan
    subnet ? subnet['vlanid'] : nil
  end

  def vlan=(value)
    subnets.update({'id' => id, 'subnet' => {'vlanid' => value}})
  end

  def domains
    subnet ? subnet['domain_ids'].collect { |dom_id| domain_name(dom_id) } : nil
  end

  def domains=(value)
    domain_ids = value.collect { |name| domain_id(name) }
    subnets.update({'id' => id, 'subnet' => {'domain_ids' => domain_ids}})
  end

  def dhcp_proxy
    subnet ? smartproxy_name(subnet['dhcp_id']) : nil
  end

  def dhcp_proxy=(value)
    subnets.update({'id' => id, 'subnet' => {'dhcp_id' => smartproxy_id(value)}})
  end

  def tftp_proxy
    subnet ? smartproxy_name(subnet['tftp_id']) : nil
  end

  def tftp_proxy=(value)
    subnets.update({'id' => id, 'subnet' => {'tftp_id' => smartproxy_id(value)}})
  end

  def dns_proxy
    subnet ? smartproxy_name(subnet['dns_id']) : nil
  end

  def dns_proxy=(value)
    subnets.update({'id' => id, 'subnet' => {'dns_id' => smartproxy_id(value)}})
  end

  ## Helper functions
  ##

  private

  def api_domains
    @api_domains ||= ForemanApi::Resources::Domain.new({
      :base_url => resource[:base_url],
      :oauth    => {
        :consumer_key    => resource[:consumer_key],
        :consumer_secret => resource[:consumer_secret]
      }
    }, {
      :headers => {
        :foreman_user => resource[:effective_user]
      }
    })
  end

  def domain_name(id)
    spi = api_domains.index[0]
    if spi.is_a?(Hash) && spi.has_key?('results')
      # foreman_api 0.1.18+
      result = spi['results'].find { |s| s['id'] == id }
    else
      # foreman_api < 0.1.18
      result = spi.find { |s| s['domain']['id'] == id }['domain']
    end
    result['name']
  end

  def domain_id(name)
    spi = api_domains.index[0]
    if spi.is_a?(Hash) && spi.has_key?('results')
      # foreman_api 0.1.18+
      result = spi['results'].find { |s| s['name'] == name }
    else
      # foreman_api < 0.1.18
      result = spi.find { |s| s['domain']['name'] == name }['domain']
    end
    result['id']
  end

  def api_smartproxies
    @api_smartproxies ||= ForemanApi::Resources::SmartProxy.new({
      :base_url => resource[:base_url],
      :oauth    => {
        :consumer_key    => resource[:consumer_key],
        :consumer_secret => resource[:consumer_secret]
      }
    }, {
      :headers => {
        :foreman_user => resource[:effective_user]
      }
    })
  end

  def smartproxy_id(name)
    spi = api_smartproxies.index[0]
    if spi.is_a?(Hash) && spi.has_key?('results')
      # foreman_api 0.1.18+
      result = spi['results'].find { |s| s['name'] == name }
    else
      # foreman_api < 0.1.18
      result = spi.find { |s| s['smartProxy']['name'] == name }['smartProxy']
    end
    result['id']
  end

  def smartproxy_name(id)
    spi = api_smartproxies.index[0]
    if spi.is_a?(Hash) && spi.has_key?('results')
      # foreman_api 0.1.18+
      result = spi['results'].find { |s| s['id'] == id }
    else
      # foreman_api < 0.1.18
      result = spi.find { |s| s['smartProxy']['id'] == id }['smartProxy']
    end
    result ? result['name'] : nil
  end
end
