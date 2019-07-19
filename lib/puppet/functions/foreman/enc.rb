Puppet::Functions.create_function(:'foreman::enc') do
  dispatch :foreman_enc do
    # Copied from Stdlib::HTTPUrl
    param 'Struct[{url=>Pattern[/(?i:^https?:\/\/)/]}]', :options
    param 'Puppet::LookupContext', :context
  end

  argument_mismatch :missing_path do
    param 'Hash', :options
    param 'Puppet::LookupContext', :context
  end

  def parse_error(body)
    begin
      require 'json'
      content = JSON.parse(body)
    rescue
      content = body
    end

    begin
      content['error']['message']
    rescue
      "Check Foreman's production log for more information."
    end
  end

  def enc(url, certname)
    # Doesn't support JSON
    headers = { 'Accept' => 'application/yaml' }
    options = {}
    uri = URI.parse("#{url}/node/#{certname}?format=yml")

    # The API doesn't accept SSL certificate authentication
    if uri.user && uri.password
      headers['Accept'] = 'application/json'
      uri = URI.parse("#{url}/api/hosts/#{certname}/enc")
      options[:basic_auth] = {
        :user => uri.user,
        :password => uri.password
      }
    end

    use_ssl = uri.scheme == 'https'
    ssl_context = use_ssl ? Puppet.lookup(:ssl_context) : nil
    conn = Puppet::Network::HttpPool.connection(uri.host, uri.port, use_ssl: use_ssl, ssl_context: ssl_context)

    # Puppetserver doesn't implement HTTP auth on get requests
    # https://tickets.puppetlabs.com/browse/SERVER-2597
    if defined?(Puppet::Server::HttpClient) && conn.is_a?(Puppet::Server::HttpClient) && options[:basic_auth]
      require 'base64'
      encoded = Base64.strict_encode64("#{options[:basic_auth][:user]}:#{options[:basic_auth][:password]}")
      headers["Authorization"] = "Basic #{encoded}"
    end

    path = uri.path
    path += "?#{uri.query}" if uri.query
    response = conn.get(path, headers, options)

    raise "#{response.class}; #{parse_error(response.body)} using #{conn}" unless response.code == "200"

    case response['Content-Type'].split(';').first
    when 'application/json'
      require 'json'
      data = JSON.parse(response.body)
      raise Exception, "Empty JSON response from ENC" if data.nil?
      data['data']
    when 'application/yaml'
      Puppet::Util::Yaml.safe_load(response.body, [Symbol])
    when 'text/plain'
      # The node data sends it as text/plain rather than application/yaml
      Puppet::Util::Yaml.safe_load(response.body, [Symbol])
    else
      raise Exception, "Unable to handle content type #{response['Content-Type']}"
    end
  end

  def foreman_enc(options, context)
    begin
      data = enc(options['url'], Puppet[:certname])
    rescue Puppet::Util::Yaml::YamlLoadError => ex
      raise Puppet::DataBinding::LookupError, _("Unable to parse %{message}") % { message: ex.message }
    rescue Exception => ex
      raise Puppet::DataBinding::LookupError, _("Unable to load ENC for %{certname} %{message}") % { certname: Puppet[:certname], message: ex.message }
    end

    result = {}

    result.update(data['parameters']) if data['parameters']

    if data['classes'].is_a?(Hash)
      result['classes'] = data['classes'].keys

      data['classes'].each_pair do |cls, parameters|
        parameters.each_pair do |parameter, value|
          result["#{cls}::#{parameter}"] = value
        end
      end
    elsif data['classes'].is_a?(Array)
      result['classes'] = data['classes']
    end

    result
  end

  def missing_path(options, context)
    "'url' must be declared in hiera.yaml when using this data_hash function"
  end
end
