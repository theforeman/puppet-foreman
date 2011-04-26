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

require "rubygems"
require "rest_client"
require "uri"
require "timeout"


module Puppet::Parser::Functions
  newfunction(:foreman, :type => :rvalue) do |args|
    #URL to query
    foreman_url  = "http://foreman"
    foreman_user = "admin"
    foreman_pass = "changeme"

    resource     = RestClient::Resource.new(foreman_url,{ :user => foreman_user, :password =>  foreman_pass,
                                            :headers => { :accept => :json, :content_type => :json }})

    # extend this as required
    searchable_items = %w{ hosts puppetclasses fact_values environments hostgroups }
    item, search = args
    raise Puppet::ParseError, "Foreman: Invalid item to search on: #{item}, must be one of #{searchable_items.join(", ")}." unless searchable_items.include?(item)

    begin
      Timeout::timeout(5) { PSON.parse resource[URI.escape("#{item}?search=#{search}")].get.body }
    rescue Exception => e
      raise Puppet::ParseError, "Failed to contact Foreman #{e}"
    end

  end
end
