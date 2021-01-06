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

    validate_features!(resource[:features], features_list(JSON.load(r.body)))
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

    validate_features!(resource[:features], features_list(proxy))
  end

  private

  def features_list(proxy)
    proxy['features'].map { |ft| ft['name'] }.sort
  end

  def validate_features!(expected, actual)
    missing_features = expected - actual
    raise Puppet::Error.new("Proxy #{resource[:name]} has failed to load one or more features (#{missing_features.join(", ")}), check /var/log/foreman-proxy/proxy.log for configuration errors") unless missing_features.empty?
  end
end
