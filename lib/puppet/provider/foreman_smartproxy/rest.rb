Puppet::Type.type(:foreman_smartproxy).provide(:rest) do

  confine :feature => :foreman_api

  def smartProxies
    ForemanApi::Resources::SmartProxy.new({
      :base_url => resource[:base_url],
      :oauth    => {
        :consumer_key    => resource[:consumer_key],
        :consumer_secret => resource[:consumer_secret]
      }
    },{
      :headers => {
        :foreman_user => resource[:effective_user]
      }})
  end

  def proxy
    if @proxy
      @proxy
    else
      spi = smartProxies.index[0]
      if spi.is_a?(Hash) && spi.has_key?('results')
        # foreman_api 0.1.18+
        @proxy = spi['results'].find { |s| s['name'] == resource[:name] }
      else
        # foreman_api < 0.1.18
        @proxy = spi.find { |s| s['smart_proxy']['name'] == resource[:name] }['smart_proxy']
      end
    end
  end

  def id
    proxy ? proxy['id'] : nil
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
    @proxy = nil
  end

  def url
    proxy ? proxy['url'] : nil
  end

  def url=(value)
    smartProxies.update({'id' => id, 'smart_proxy' => {'url' => value}})
  end

end
