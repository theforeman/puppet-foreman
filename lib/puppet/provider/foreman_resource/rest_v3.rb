# Base provider for other Puppet types managing Foreman resources
#
# This provider uses Net::HTTP from Ruby stdlib, JSON and the oauth gem for
# auth, so requiring minimal dependencies.

require 'cgi'
require 'uri'

Puppet::Type.type(:foreman_resource).provide(:rest_v3) do
  # when previous providers are installed, use this one
  def self.specificity
    super + 2
  end

  def oauth_consumer_key
    @oauth_consumer_key ||= begin
      if resource[:consumer_key]
        resource[:consumer_key]
      else
        begin
          YAML.load_file('/etc/foreman/settings.yaml')[:oauth_consumer_key]
        rescue
          fail "Resource #{resource[:name]} cannot be managed: No OAuth Consumer Key available"
        end
      end
    end
  end

  def oauth_consumer_secret
    @oauth_consumer_secret ||= begin
      if resource[:consumer_secret]
        resource[:consumer_secret]
      else
        begin
          YAML.load_file('/etc/foreman/settings.yaml')[:oauth_consumer_secret]
        rescue
          fail "Resource #{resource[:name]} cannot be managed: No OAuth consumer secret available"
        end
      end
    end
  end

  def foreman_url
    @foreman_url ||= begin
      if resource[:base_url]
        resource[:base_url]
      else
        begin
          YAML.load_file('/etc/foreman-proxy/settings.yml')[:foreman_url]
        rescue
          fail "Resource #{resource[:name]} cannot be managed: No base_url available"
        end
      end
    end
  end

  def oauth_consumer
    @consumer ||= OAuth::Consumer.new(oauth_consumer_key, oauth_consumer_secret, {
      :site               => foreman_url,
      :request_token_path => '',
      :authorize_path     => '',
      :access_token_path  => '',
      :timeout            => resource[:timeout],
      :ca_file            => resource[:ssl_ca]
    })
  end

  def generate_token
    OAuth::AccessToken.new(oauth_consumer)
  end

  def request_uri(path)
    base_url = foreman_url
    base_url += '/' unless base_url.end_with?('/')
    URI.join(base_url, path)
  end

  def request(method, path, params = {}, data = nil, headers = {})
    uri = request_uri(path)
    uri.query = params.map { |p,v| "#{CGI.escape(p.to_s)}=#{CGI.escape(v.to_s)}" }.join('&') unless params.empty?

    headers = {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'foreman_user' => resource[:effective_user]
    }.merge(headers)

    attempts = 0
    begin
      debug("Making #{method} request to #{uri}")
      if [:post, :put, :patch].include?(method)
        response = oauth_consumer.request(method, uri.to_s, generate_token, {}, data, headers)
      else
        response = oauth_consumer.request(method, uri.to_s, generate_token, {}, headers)
      end
      debug("Received response #{response.code} from request to #{uri}")
      response
    rescue Timeout::Error => te
      attempts = attempts + 1
      if attempts < 5
        warning("Timeout calling API at #{uri}. Retrying ..")
        retry
      else
        raise Puppet::Error.new("Timeout calling API at #{uri}", te)
      end
    rescue Exception => ex
      raise Puppet::Error.new("Exception #{ex} in #{method} request to: #{uri}", ex)
    end
  end

  def success?(response)
    (200..299).include?(response.code.to_i)
  end

  def error_message(response)
    fqdn = URI::parse(foreman_url).host

    explanations = {
      '400' => "Something is wrong with the data sent to Foreman at #{fqdn}",
      '401' => "Often this is caused by invalid Oauth credentials sent to Foreman at #{fqdn}",
      '404' => "The requested resource was not found in Foreman at #{fqdn}",
      '500' => "Check /var/log/foreman/production.log on #{fqdn} for detailed information",
      '502' => "The webserver received an invalid response from the backend service. Was Foreman at #{fqdn} unable to handle the request?",
      '503' => "The webserver was unable to reach the backend service. Is Foreman running at #{fqdn}?",
      '504' => "The webserver timed out waiting for a response from the backend service. Is Foreman at #{fqdn} under unusually heavy load?"
    }

    if (explanation = explanations[response.code.to_str])
      "Response: #{response.code} #{response.message}: #{explanation}"
    else
      JSON.parse(response.body)['error']['full_messages'].join(' ') rescue "Response: #{response.code} #{response.message}"
    end
  end

  def search(resource, key, value)
    path = "api/v2/#{resource}"
    req = request(:get, path, search: %(#{key}="#{value}"))

    unless success?(req)
      raise Puppet::Error, "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(req)}"
    end

    JSON.parse(req.body)['results']
  end

  def location_id(name)
    res = search('locations', 'name', name).first
    res.nil? ? nil : res['id']
  end

  def organization_id(name)
    res = search('organizations', 'name', name).first
    res.nil? ? nil : res['id']
  end
end
