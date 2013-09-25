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
    # parse an args hash
    raise Puppet::ParseError, "Foreman: Must supply a Hash to foreman(), not a #{args[0].class}" unless args[0].is_a? Hash
    args_hash    = args[0]
    item         = args_hash["item"]
    search       = args_hash["search"]
    foreman_url  = args_hash["foreman_url"]  || "https://localhost" # defaults: all-in-one
    foreman_user = args_hash["foreman_user"] || "admin"             # has foreman/puppet
    foreman_pass = args_hash["foreman_pass"] || "changeme"          # on the same box

    # extend this as required
    searchable_items = %w{ hosts puppetclasses fact_values environments hostgroups }
    raise Puppet::ParseError, "Foreman: Invalid item to search on: #{item}, must be one of #{searchable_items.join(", ")}." unless searchable_items.include?(item)

    begin
      path = URI.escape("/api/#{item}?search=#{search}")
      uri = URI.parse(foreman_url)

      req = Net::HTTP::Get.new(path)
      req.basic_auth(foreman_user, foreman_pass)
      req['Content-Type'] = 'application/json'
      req['Accept'] = 'application/json'

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?
      Timeout::timeout(5) { PSON.parse http.request(req).body }
    rescue Exception => e
      raise Puppet::ParseError, "Failed to contact Foreman at #{foreman_url}: #{e}"
    end
  end
end
