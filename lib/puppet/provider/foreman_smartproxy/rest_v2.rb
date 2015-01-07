Puppet::Type.type(:foreman_smartproxy).provide(:rest_v2) do

  confine :feature => :apipie_bindings

  # when both rest and rest_v2 providers are installed, use this one
  def self.specificity
    super + 1
  end

  def api
    @api ||= ApipieBindings::API.new({
      :uri => resource[:base_url],
      :api_version => 2,
      :oauth => {
        :consumer_key    => resource[:consumer_key],
        :consumer_secret => resource[:consumer_secret]
      },
      :timeout => resource[:timeout],
      :headers => {
        :foreman_user => resource[:effective_user],
      },
      :apidoc_cache_base_dir => File.join(Puppet[:vardir], 'apipie_bindings')
    }).resource(:smart_proxies)
  end

  # proxy hash or nil
  def proxy
    if @proxy
      @proxy
    else
      @proxy = api.call(:index, :search => "name=#{resource[:name]}")['results'][0]
    end
  end

  def id
    proxy ? proxy['id'] : nil
  end

  def exists?
    ! id.nil?
  end

  def create
    api.call(:create, {
      :smart_proxy => {
        :name => resource[:name],
        :url  => resource[:url]
      }
    })
  end

  def destroy
    api.call(:destroy, :id => id)
    @proxy = nil
  end

  def url
    proxy ? proxy['url'] : nil
  end

  def url=(value)
    api.call(:update, { :id => id, :smart_proxy => { :url => value } })
  end

  def refresh_features!
    api.call(:refresh, :id => id)
  end

end
