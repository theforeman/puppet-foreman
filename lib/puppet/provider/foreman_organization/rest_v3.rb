# frozen_string_literal: true

Puppet::Type.type(:foreman_organization).provide( # rubocop:disable Metrics/BlockLength
  :rest_v3,
  parent: Puppet::Type.type(:foreman_resource).provider(:rest_v3)
) do
  desc 'foreman_organization configures a organization in foreman.'
  confine feature: %i[json oauth]

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def organization # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @organization ||= begin
      org_search = search('organizations', 'name', resource[:name]).first

      return nil if org_search.nil?

      path = "api/v2/organizations/#{org_search['id']}"
      req = request(:get, path)

      unless success?(req)
        raise Puppet::Error, "Error making GET request to Foreman at #{request_uri(path)}: #{error_message(req)}"
      end

      result = JSON.parse(req.body)
      debug("Using Foreman Organization '#{resource[:name]}' with: #{result}")
      result
    end
  end

  def id
    organization['id'] if organization
  end

  def exists?
    !id.nil?
  end

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    debug("Creating Foreman Organization #{resource[:name]}")

    path = 'api/v2/organizations'
    payload = {
      organization: {
        name: resource[:name],
        parent_id: resource[:parent] ? organization_id(resource[:parent]) : nil,
        description: resource[:description],
        ignore_types: resource[:select_all_types],
        domain_ids: domain_ids(resource[:domains]),
        location_ids: location_ids(resource[:locations])
      }
    }
    req = request(:post, path, {}, payload.to_json)

    return if success?(req)

    raise Puppet::Error, "Error making POST request to Foreman at #{request_uri(path)}: #{error_message(req)}"
  end

  def destroy
    debug("Destroying Foreman Organization #{resource[:name]}")

    path = "api/v2/organizations/#{id}"
    req = request(:delete, path)

    unless success?(req)
      raise Puppet::Error, "Error making DELETE request to Foreman at #{request_uri(path)}: #{error_message(req)}"
    end

    @organization = nil
  end

  def flush
    return if @property_flush.empty?

    debug("Calling API to update properties for Foreman Organization #{resource[:name]} with: #{@property_flush}")

    path = "api/v2/organizations/#{id}"
    req = request(:put, path, {}, { organization: @property_flush }.to_json)

    return if success?(req)

    raise Puppet::Error, "Error making PUT request to Foreman at #{request_uri(path)}: #{error_message(req)}"
  end

  def parent
    organization && organization['parent_name'] ? organization['parent_name'].split('/')[-1] : nil
  end

  def parent=(value)
    if value.nil?
      @property_flush[:parent_id] = nil
    else
      parent_id = organization_id(value)

      raise Puppet::Error, "Could not find Foreman Organzation with name #{value} as parent." if parent_id.nil?

      @property_flush[:parent_id] = parent_id
    end
  end

  def description
    organization ? organization['description'] : nil
  end

  def description=(value)
    @property_flush[:description] = value
  end

  def select_all_types
    organization ? organization['select_all_types'] : []
  end

  def select_all_types=(value)
    @property_flush[:ignore_types] = value
  end

  def domains
    organization ? organization['domains'].reject { |d| d['inherited'] }.map { |d| d['name'] } : nil
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

  def locations
    organization ? organization['locations'].reject { |l| l['inherited'] }.map { |l| l['name'] } : nil
  end

  def location_ids(locations)
    return nil if locations.nil?

    locations.map do |location|
      location_id = location_id(location)

      raise Puppet::Error, "Could not find Foreman Location with name '#{location}'" if location_id.nil?

      location_id
    end
  end

  def locations=(value)
    @property_flush[:location_ids] = location_ids(value)
  end
end
