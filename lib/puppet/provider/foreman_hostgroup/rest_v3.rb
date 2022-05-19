# frozen_string_literal: true

Puppet::Type.type(:foreman_hostgroup).provide(
  :rest_v3,
  parent: Puppet::Type.type(:foreman_resource).provider(:rest_v3)
) do
  confine feature: %i[json oauth]

  def initialize(value = {})
    super
    @property_flush = {}
  end

  def exists?
    !id.nil?
  end

  def create
    debug("Creating Foreman Hostgroup #{resource[:name]} with parent #{resource[:parent_hostgroup]}")

    if resource[:parent_hostgroup] && parent_hostgroup_id.nil?
      raise Puppet::Error,
            "Parent hostgroup #{resource[:parent_hostgroup]} for #{resource[:name]} not found"
    end

    organization_ids = resource[:organizations]&.map { |org| organization_id(org) }
    location_ids = resource[:locations]&.map { |loc| location_id(loc) }

    post_data = {
      hostgroup: {
        name: resource[:name],
        parent_id: parent_hostgroup_id,
        description: resource[:description],
        organization_ids: organization_ids,
        location_ids: location_ids
      }
    }.to_json
    path = 'api/v2/hostgroups'
    r = request(:post, path, {}, post_data)

    return if success?(r)

    raise Puppet::Error, "Error making POST request to Foreman at #{request_uri(path)}: #{error_message(r)}"
  end

  def destroy
    debug("Destroying Foreman Hostgroup #{resource[:name]} with parent #{resource[:parent_hostgroup]}")
    path = "api/v2/hostgroups/#{id}"
    r = request(:delete, path)

    unless success?(r)
      error_string = "Error making DELETE request to Foreman at #{request_uri(path)}: #{error_message(r)}"
      raise Puppet::Error, error_string
    end

    @hostgroup = nil
  end

  def flush
    return if @property_flush.empty?

    debug "Calling API to update properties for #{resource[:name]}"

    path = "api/v2/hostgroups/#{id}"
    r = request(:put, path, {}, { hostgroup: @property_flush }.to_json)

    return if success?(r)

    raise Puppet::Error, "Error making PUT request to Foreman at #{request_uri(path)}: #{error_message(r)}"
  end

  # Property getters
  def description
    hostgroup ? hostgroup['description'] : nil
  end

  def organizations
    hostgroup ? hostgroup['organizations'].map { |org| org['title'] } : nil
  end

  def locations
    hostgroup ? hostgroup['locations'].map { |org| org['title'] } : nil
  end

  # Property setters
  # If one of more properties is being modified then group all of these updates in @property_flush so that we can update them in a single API call in `flush()`
  def description=(value)
    @property_flush[:description] = value
  end

  def organizations=(value)
    @property_flush[:organization_ids] = value.map { |org| organization_id(org) }
  end

  def locations=(value)
    @property_flush[:location_ids] = value.map { |loc| location_id(loc) }
  end

  private

  def hostgroup
    @hostgroup ||= begin
      path = 'api/v2/hostgroups'
      search_name = resource[:name]
      search_title = if resource[:parent_hostgroup]
                       "#{resource[:parent_hostgroup]}/#{resource[:name]}"
                     else
                       search_name
                     end
      debug("Searching for hostgroup with name #{search_name} and title #{search_title}")
      r = request(:get, path, search: %(title="#{search_title}" and name="#{search_name}"))

      raise Puppet::Error, "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(r)}" unless success?(r)

      results = JSON.parse(r.body)['results']
      unless results.empty?
        raise Puppet::Error, "Too many hostgroups found when looking for hostgroup with name #{search_name} and title #{search_title}" if results.size > 1

        get_hostgroup_by_id(results[0]['id'])
      end
    end
  end

  def get_hostgroup_by_id(id)
    path = "api/v2/hostgroups/#{id}"
    r = request(:get, path)

    raise Puppet::Error, "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(r)}" unless success?(r)

    JSON.parse(r.body)
  end

  def id
    hostgroup ? hostgroup['id'] : nil
  end

  def parent_hostgroup
    return nil unless resource[:parent_hostgroup]

    @parent_hostgroup ||= begin
      path = 'api/v2/hostgroups'
      search_title = resource[:parent_hostgroup]
      search_name = resource[:parent_hostgroup_name] || search_title.split('/').last
      debug("Searching for parent hostgroup with name #{search_name} and title #{search_title}")
      r = request(:get, path, search: %(title="#{search_title}" and name="#{search_name}"))

      raise Puppet::Error, "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(r)}" unless success?(r)

      results = JSON.parse(r.body)['results']
      raise Puppet::Error, "Parent hostgroup #{resource[:parent_hostgroup]} for #{resource[:name]} not found" if results.empty?
      raise Puppet::Error, "Too many hostgroups found when looking for parent hostgroup with name #{search_name} and title #{search_title}" if results.size > 1

      get_hostgroup_by_id(results[0]['id'])
    end
  end

  def parent_hostgroup_id
    parent_hostgroup ? parent_hostgroup['id'] : nil
  end

  def organization_id(organization_title)
    title_to_id('organizations', organization_title)
  end

  def location_id(location_title)
    title_to_id('locations', location_title)
  end

  # Returns the id of a location/organization based on its title
  def title_to_id(type, title)
    path = "api/v2/#{type}"
    r = request(:get, path, search: %(title="#{title}"))
    unless success?(r)
      raise Puppet::Error,
            "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(r)}"
    end
    results = JSON.parse(r.body)['results']
    raise Puppet::Error, "#{title} not found in #{type}" unless results.size == 1

    results[0]['id']
  end
end
