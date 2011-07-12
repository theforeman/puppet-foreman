# Query Foreman in order to resolv a smart variable
# Foreman holds all the value names and their possible values,
# this function simply ask foreman for the right value for this host.

require "rubygems"
require "rest_client"
require "uri"
require "timeout"

module Puppet::Parser::Functions
  newfunction(:smartvar, :type => :rvalue) do |args|
    #URL to query
    foreman_url  = "http://foreman"
    foreman_user = "admin"
    foreman_pass = "changeme"

    resource     = RestClient::Resource.new(foreman_url,{ :user => foreman_user, :password => foreman_pass,
                                            :headers => { :accept => :json, :content_type => :json }})

    # extend this as required
    var = args[0]
    raise Puppet::ParseError, "Must provide a variable name to search for" if var.nil?

    fqdn = lookupvar("fqdn")

    begin
      Timeout::timeout(5) { PSON.parse(resource[URI.escape("/hosts/#{fqdn}/lookup_keys/#{var}")].get.body)["value"] }
    rescue Exception => e
      raise Puppet::ParseError, "Failed to contact Foreman #{e}"
    end

  end
end
