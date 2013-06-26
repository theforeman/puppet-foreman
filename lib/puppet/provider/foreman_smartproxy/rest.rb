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
    @proxy ||= smartProxies.index[0].find { |s| s['smart_proxy']['name'] == resource[:name] }
  end

  def id
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
    @proxy = nil
  end

  def url
    proxy ? proxy['smart_proxy']['url'] : nil
  end

  def url=(value)
    smartProxies.update({'id' => id, 'smart_proxy' => {'url' => value}})
  end

end
