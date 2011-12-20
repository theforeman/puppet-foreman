# Query Foreman
# example usage:
#
# query for hosts
# ~~~~~~~~~~~~~~~
# $myhosts = foreman("hosts","facts.domain ~ lab")
# returns all hosts which have lab as part of their domain.
#
# or a more complex search term
# $myhosts = foreman("hosts", "hostgroup ~ web and environment = production and status.failed = 0 and facts.timezone = EST and last_report < \"1 hour ago\""
#
# query for facts
# ~~~~~~~~~~~~~~~
# get manufactor value for host "xyz"
# $manufactor = foreman("fact_values", "name = manufacturer and host = xyz"
# which in this case will return a hash
# {"xyz":{"manufacturer":"LENOVO"}}

require "net/http"
require "net/https"
require "uri"
require "timeout"

module Puppet::Parser::Functions
  newfunction(:foreman, :type => :rvalue) do |args|
    # extend this as required
    searchable_items = %w{ hosts puppetclasses fact_values environments hostgroups }
    item, search = args
    raise Puppet::ParseError, "Foreman: Invalid item to search on: #{item}, must be one of #{searchable_items.join(", ")}." unless searchable_items.include?(item)

    # URL to query
    foreman_url  = "https://foreman"
    foreman_user = "admin"
    foreman_pass = "changeme"

    uri = URI.parse(foreman_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'

    path = URI.escape("/#{item}?search=#{search}")
    req = Net::HTTP::Get.new(path)
    req.basic_auth(foreman_user, foreman_pass)
    req['Content-Type'] = 'application/json'
    req['Accept'] = 'application/json'

    begin
      Timeout::timeout(5) { PSON.parse http.request(req).body }
    rescue Exception => e
      raise Puppet::ParseError, "Failed to contact Foreman #{e}"
    end

  end
end
