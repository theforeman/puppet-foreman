Puppet::Type.type(:foreman_domain).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_resource).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def exists?
    !id.nil?
  end

  def create
    path = "api/v2/domains"
    payload = {
      :domain => {
        :name => resource[:name],
        :fullname => resource[:fullname],
        :dns_id => search('smart_proxies', resource[:dns_id]),
      }
    }

    req = request(:post, path, {}, payload.to_json)

    unless success?(req)
      error_string = "Error making POST request to Foreman at #{request_uri(path)}: #{error_message(req)}"
      raise Puppet::Error.new(error_string)
    end
  end

  def destroy
    req = request(:delete, destroy_path, {})

    unless success?(req)
      error_string = "Error making DELETE request to Foreman at #{request_uri(path)}: #{error_message(req)}"
      raise Puppet::Error.new(error_string)
    end
  end

  def id
    domain['id'] if domain
  end

  def domain
    @domain ||= begin
      path = 'api/v2/domains'
      req = request(:get, path, :search => %{name="#{resource[:name]}"})

      unless success?(req)
        error_string = "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(req)}"
        raise Puppet::Error.new(error_string)
      end

      JSON.load(req.body)['results'].first
    end
  end

  private

  def destroy_path
    "api/v2/domains/#{id}"
  end
end
