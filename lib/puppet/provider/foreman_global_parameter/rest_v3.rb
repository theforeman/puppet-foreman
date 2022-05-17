# frozen_string_literal: true

Puppet::Type.type(:foreman_global_parameter)
            .provide(
              :rest_v3,
              parent: Puppet::Type.type(:foreman_resource).provider(:rest_v3)
            ) do
  confine feature: %i[json oauth]

  mk_resource_methods

  # Note that #request is an instance method and as such prevents
  # self.instances and self.prefetch from being implimented.

  # The foreman api has both `hidden_value` and `hidden_value?` fields. The
  # later is the boolean value.
  def hidden_value
    @property_hash[:hidden_value?]
  end

  def hidden_value=(value)
    @property_hash[:hidden_value?] = value
  end

  def create
    @property_hash[:ensure] = :present
  end

  def exists?
    get_common_parameter!
    @property_hash[:ensure] == :present
  end

  def destroy
    @property_hash[:ensure] = :absent
  end

  def flush
    case self.ensure
    when :present
      # if there is already an id, this is an update
      if id.nil?
        create_common_parameter
      else
        update_common_parameter
      end
    when :absent
      destroy_common_parameter
    else
      raise Puppet::Error, "invalid :ensure value: #{self.ensure}"
    end
  end

  private

  def id
    @property_hash[:id]
  end

  def base_path
    'api/v2/common_parameters'
  end

  def get_common_parameter!
    path = base_path
    params = {
      search: "name=#{resource[:name]}",
      show_hidden: true
    }
    r = request(:get, base_path, params)

    raise Puppet::Error, "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(r)}" unless success?(r)

    begin
      results = JSON.parse(r.body)['results'].first
    rescue JSON::ParserError
      raise Puppet::Error, "unable to parse as JSON: #{r.body}"
    end

    if results.nil?
      @property_hash[:ensure] = :absent
    else
      @property_hash = results.transform_keys(&:to_sym).transform_values do |v|
        resource.munge_boolean_to_symbol(v)
      end
      @property_hash[:ensure] = :present
    end
  end

  def create_common_parameter
    path = base_path
    data = {
      common_parameter: {
        name: resource[:name],
        value: resource[:value],
        parameter_type: resource[:parameter_type]
      }
    }
    data[:hidden_value] = resource[:hidden_value] unless resource[:hidden_value].nil?
    data.transform_values! { |v| resource.munge_symbol_to_boolean(v) }
    r = request(:post, path, {}, data.to_json)

    return if success?(r)

    raise Puppet::Error, "Error making POST request to Foreman at #{request_uri(path)}: #{error_message(r)}"
  end

  def update_common_parameter
    path = "#{base_path}/#{id}"
    data = {
      common_parameter: {
        name: resource[:name],
        value: resource[:value],
        parameter_type: resource[:parameter_type]
      }
    }
    data[:hidden_value] = resource[:hidden_value] unless resource[:hidden_value].nil?
    data.transform_values! { |v| resource.munge_symbol_to_boolean(v) }
    r = request(:put, path, {}, data.to_json)

    return if success?(r)

    raise Puppet::Error, "Error making PUT request to Foreman at #{request_uri(path)}: #{error_message(r)}"
  end

  def destroy_common_parameter
    path = "#{base_path}/#{id}"
    r = request(:delete, path)

    unless success?(r)
      error_string = "Error making DELETE request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error, error_string
    end

    @property_hash.clear
  end
end
