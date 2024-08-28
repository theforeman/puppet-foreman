# frozen_string_literal: true

Puppet::Type.type(:foreman_location).provide( # rubocop:disable Metrics/BlockLength
  :rest_v3,
  parent: Puppet::Type.type(:foreman_resource).provider(:rest_v3)
) do
  desc 'foreman_location configures a location in foreman.'
  confine feature: %i[json oauth]

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def location # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @location ||= begin
      loc_search = search('locations', 'name', resource[:name]).first

      return nil if loc_search.nil?

      path = "api/v2/locations/#{loc_search['id']}"
      req = request(:get, path)

      unless success?(req)
        raise Puppet::Error, "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(req)}"
      end

      result = JSON.parse(req.body)
      debug("Using Foreman Location '#{resource[:name]}' with: #{result}")
      result
    end
  end

  def id
    location['id'] if location
  end

  def exists?
    !id.nil?
  end

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    debug("Creating Foreman Location #{resource[:name]}")

    path = 'api/v2/locations'
    payload = {
      location: {
        name: resource[:name],
        parent_id: resource[:parent] ? location_id(resource[:parent]) : nil,
        description: resource[:description],
        ignore_types: resource[:select_all_types],
        domain_ids: domain_ids(resource[:domains]),
        organization_ids: organization_ids(resource[:organizations])
      }
    }
    req = request(:post, path, {}, payload.to_json)

    return if success?(req)

    raise Puppet::Error, "Error making POST request to Foreman at #{request_uri(path)}: #{error_message(req)}"
  end

  def destroy
    debug("Destroying Foreman Location #{resource[:name]}")

    path = "api/v2/locations/#{id}"
    req = request(:delete, path)

    unless success?(req)
      raise Puppet::Error, "Error making DELETE request to Foreman at #{request_uri(path)}: #{error_message(req)}"
    end

    @location = nil
  end

  def flush
    return if @property_flush.empty?

    debug("Calling API to update properties for Foreman Location #{resource[:name]} with: #{@property_flush}")

    path = "api/v2/locations/#{id}"
    req = request(:put, path, {}, { location: @property_flush }.to_json)

    return if success?(req)

    raise Puppet::Error, "Error making PUT request to Foreman at #{request_uri(path)}: #{error_message(r)}"
  end

  def parent
    location && location['parent_name'] ? locations['parent_name'].split('/')[-1] : nil
  end

  def parent=(value)
    if value.nil?
      @property_flush[:parent_id] = nil
    else
      parent_id = location_id(value)

      raise Puppet::Error, "Could not find Foreman Location with name #{value} as parent." if parent_id.nil?

      @property_flush[:parent_id] = parent_id
    end
  end

  def description
    location ? location['description'] : nil
  end

  def description=(value)
    @property_flush[:description] = value
  end

  def select_all_types
    location ? location['select_all_types'] : []
  end

  def select_all_types=(value)
    @property_flush[:ignore_types] = value
  end

  def domains
    location ? location['domains'].reject { |d| d['inherited'] }.map { |d| d['name'] } : nil
  end

  def domain_ids(domains)
    return nil if domains.nil?

    domains.map do |domain|
      res = search('domains', 'name', domain).first

      raise Puppet::Error, "Could not find Foreman Domain with name '#{domain}'" if res.nil?

      res['id']
    end
  end

  def domains=(value)
    @property_flush[:domain_ids] = domain_ids(value)
  end

  def organizations
    location ? location['organizations'].reject { |o| o['inherited'] }.map { |o| o['name'] } : nil
  end

  def organization_ids(orgs)
    return nil if orgs.nil?

    orgs.map do |organization|
      org_id = organization_id(organization)

      raise Puppet::Error, "Could not find Foreman Organization with name '#{organization}'" if org_id.nil?

      org_id
    end
  end

  def organizations=(value)
    @property_flush[:organization_ids] = organization_ids(value)
  end
end
