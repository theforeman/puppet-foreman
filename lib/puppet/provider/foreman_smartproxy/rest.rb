Puppet::Type.type(:foreman_smartproxy).provide(:rest) do

  confine :feature => :foreman_api

  def smartProxies
    ForemanApi::Resources::SmartProxy.new(
      :base_url => resource[:base_url],
      :oauth    => {
        :consumer_key    => resource[:consumer_key],
        :consumer_secret => resource[:consumer_secret]
      }
    )
  end

  def id
    proxy = smartProxies.index[0].find { |s| s['smart_proxy']['name'] == resource[:name] }
    proxy ? proxy['smart_proxy']['id'] : nil
  end

  def exists?
    id != nil
  end

  def create
    smartProxies.create({
      'smart_proxy' => {'name' => resource[:name], 'url' => resource[:url]}
    })
  end

  def destroy
    smartProxies.destroy({'id' => id})
  end

  def url
    smartProxies.index[0].each do |s|
      if s['smart_proxy']['name'] == resource[:name]
        return s['smart_proxy']['url']
      end
    end
  end

  def url=(value)
    smartProxies.update({'id' => id, 'smart_proxy' => {'url' => value}})
  end

end
