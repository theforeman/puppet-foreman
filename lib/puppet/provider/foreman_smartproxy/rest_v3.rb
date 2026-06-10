Puppet::Type.type(:foreman_smartproxy).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_resource).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def proxy
    @proxy ||= begin
      path = 'api/v2/smart_proxies'
      r = request(:get, path, :search => %{name="#{resource[:name]}"})

      unless success?(r)
        error_string = "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(r)}"
        raise Puppet::Error.new(error_string)
      end

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
    post_data = {:smart_proxy => {:name => resource[:name], :url => resource[:url]}}.to_json
    path = 'api/v2/smart_proxies'
    r = request(:post, path, {}, post_data)

    unless success?(r)
      error_string = "Error making POST request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error.new(error_string)
    end

    body = JSON.load(r.body)
    unless body
      raise Puppet::Error.new("Proxy #{resource[:name]}: Foreman API returned empty response body after creating proxy")
    end

    validate_features!(body)
  end

  def destroy
    path = "api/v2/smart_proxies/#{id}"
    r = request(:delete, path)

    unless success?(r)
      error_string = "Error making DELETE request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error.new(error_string)
    end

    @proxy = nil
  end

  def url
    proxy ? proxy['url'] : nil
  end

  def url=(value)
    post_data = {:smart_proxy => {:url => value}}.to_json
    path = "api/v2/smart_proxies/#{id}"
    r = request(:put, path, {}, post_data)

    unless success?(r)
      error_string = "Error making PUT request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error.new(error_string)
    end
  end

  def features
    proxy ? features_list(proxy) : []
  end

  def features=(expected_features)
    refresh_features!
  end

  def refresh_features!
    path = "api/v2/smart_proxies/#{id}/refresh"
    r = request(:put, path)

    unless success?(r)
      error_string = "Error making PUT request to #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error.new(error_string)
    end

    body = JSON.load(r.body)
    # Replace proxy/feature list cache: pre-#19476 versions have limited responses, clear cache and re-fetch for them
    @proxy = body.key?('features') ? body : nil

    validate_features!(proxy) if proxy
  end

  private

  def features_list(proxy)
    features = proxy['features']
    unless features.is_a?(Array)
      Puppet.err("Proxy #{resource[:name]}: Expected 'features' to be an array, got #{features.class}")
      return []
    end
    features.map { |ft| ft['name'] }.compact.sort
  end

  def validate_features!(proxy_data)
    unrecognized = Array(proxy_data['unrecognized_features'])
    if unrecognized.any?
      Puppet.warning("Proxy #{resource[:name]} has features not recognized by Foreman: #{unrecognized.join(', ')}. If these features come from a Smart Proxy plugin, make sure Foreman has the plugin installed too.")
    end

    actual = features_list(proxy_data)
    missing = resource[:features] - actual
    unless missing.empty?
      raise Puppet::Error.new("Proxy #{resource[:name]} has failed to load one or more features (#{missing.join(', ')}), check /var/log/foreman-proxy/proxy.log for configuration errors")
    end
  end
end
