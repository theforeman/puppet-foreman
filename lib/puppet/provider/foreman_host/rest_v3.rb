Puppet::Type.type(:foreman_host).provide(:rest_v3, :parent => Puppet::Type.type(:foreman_resource).provider(:rest_v3)) do
  confine :feature => [:json, :oauth]

  def exists?
    !id.nil?
  end

  def create
    path = "api/v2/hosts/facts"
    payload = {
      :name => resource[:hostname],
      :certname => resource[:hostname],
      :facts => resource[:facts]
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
    host['id'] if host
  end

  def host
    @host ||= begin
      path = 'api/v2/hosts'
      req = request(:get, path, :search => %{name="#{resource[:hostname]}"})

      unless success?(req)
        error_string = "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(req)}"
        raise Puppet::Error.new(error_string)
      end

      JSON.load(req.body)['results'].first
    end
  end

  private

  def destroy_path
    "api/v2/hosts/#{id}"
  end
end
