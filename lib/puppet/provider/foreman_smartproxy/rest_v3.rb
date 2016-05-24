Puppet::Type.type(:foreman_smartproxy).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_resource).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def proxy
    @proxy ||= begin
      r = request(:get, 'api/v2/smart_proxies', :search => %{name="#{resource[:name]}"})
      raise Puppet::Error.new("Proxy #{resource[:name]} cannot be retrieved: #{error_message(r)}") unless success?(r)
      JSON.load(r.body)['results'][0]
    end
  end

  def id
    proxy ? proxy['id'] : nil
  end

  def exists?
    !id.nil?
  end

  def create
    post_data = {:smart_proxy => {:name => resource[:name], :url => resource[:url]}.merge(taxonomy_params)}.to_json
    r = request(:post, 'api/v2/smart_proxies', {}, post_data)
    raise Puppet::Error.new("Proxy #{resource[:name]} cannot be registered: #{error_message(r)}") unless success?(r)
  end

  def destroy
    r = request(:delete, "api/v2/smart_proxies/#{id}")
    raise Puppet::Error.new("Proxy #{resource[:name]} cannot be removed: #{error_message(r)}") unless success?(r)
    @proxy = nil
  end

  def url
    proxy ? proxy['url'] : nil
  end

  def url=(value)
    post_data = {:smart_proxy => {:url => value}}.to_json
    r = request(:put, "api/v2/smart_proxies/#{id}", {}, post_data)
    raise Puppet::Error.new("Proxy #{resource[:name]} cannot be updated: #{error_message(r)}") unless success?(r)
  end

  def refresh_features!
    r = request(:put, "api/v2/smart_proxies/#{id}/refresh")
    raise Puppet::Error.new("Proxy #{resource[:name]} cannot be refreshed: #{error_message(r)}") unless success?(r)
  end

  def taxonomy_params
    params = {}
    params[:organization_ids] = organization_ids if organization_ids
    params[:location_ids] = location_ids if location_ids
    params
  end

  def organization_ids
    @organization_ids ||= taxonomy_ids(:organization, resource[:organizations])
  end

  def location_ids
    @location_ids ||= taxonomy_ids(:location, resource[:locations])
  end

  def taxonomy_ids(type, names)
    return unless names && names.any?
    ids = []
    names.each do |name|
      r = request(:get, "api/v2/#{type}s", :search => %{name="#{name}"})
      raise Puppet::Error.new("Could not find #{type} #{name}: #{error_message(r)}") unless success?(r)
      ids << JSON.load(r.body)['results'][0]['id']
    end
    ids
  end
end
