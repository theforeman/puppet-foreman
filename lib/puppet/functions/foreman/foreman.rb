# Query Foreman
#
# The foreman() parser takes various parameters to execute a query against the foreman-api.
#
# This sample contains parameters to let us get a list of 'hosts' that match our search parameters.
#
#        item         => 'hosts'
#        search       => 'hostgroup=Grid'
#        per_page     => '20'
#        foreman_url  => 'https://foreman'
#        foreman_user => 'my_api_foreman_user'
#        foreman_pass => 'my_api_foreman_pass'
#
# 'item' may be: environments, fact_values, hosts, hostgroups, puppetclasses, smart_proxies, subnets
# 'search' is your actual search query.
# 'per_page' specifies the maximum number of results you'd like to receive.
#            This defaults to '20' which is consistent with what you'd get from
#            Foreman if you didn't specify anything.
# 'foreman_url' is your actual foreman server address
# 'foreman_user' is the username of an account with API access
# 'foreman_pass' is the password of an account with API access
# 'filter_result' string or array with attribites to return
#                 if a string is given foreman() returns an array only with given attributes
#                 in case of an array is given foreman() returns an array of hashes selecting only
#                 attributes given in array
#                 in case of an given hash foreman() returns an array of hashes selecting only
#                 attribute keys given in hash renamed to values of given keys. This can be used
#                 to rename keys in result
# 'timeout' is the Foreman request timeout in seconds as an integer.
#           This defaults to five seconds.
#
# Then, use a variable to capture its output:
# $hosts = foreman('hosts', 'hostgroup=Grid', '20', 'https://foreman', 'my_api_foreman_user', 'my_api_foreman_pass')
#
# Note: If you're using this in a template, you may be receiving an array of
# hashes. So you might need to use two loops to get the values you need.
#
# Happy Foreman API-ing!

require "yaml"
require "net/http"
require "net/https"
require "uri"
require "timeout"

Puppet::Functions.create_function(:'foreman::foreman') do
  dispatch :foreman do
    required_param 'Enum["environments", "fact_values", "hosts", "hostgroups", "puppetclasses", "smart_proxies", "subnets"]', :item
    required_param 'String', :search
    optional_param 'Variant[Integer[0], Pattern[/\d+/]]', :per_page
    optional_param 'Stdlib::Httpurl', :foreman_url
    optional_param 'String', :foreman_user
    optional_param 'String', :foreman_pass
    optional_param 'Integer[0]', :timeout
    optional_param 'Variant[String, Array, Hash, Boolean]', :filter_result
    optional_param 'Variant[Boolean, String]', :use_tfmproxy
  end

  def foreman(item, search, per_page = "20", foreman_url = "https://localhost", foreman_user = "admin", foreman_pass = "changeme", timeout = 5, filter_result = false, use_tfmproxy = false)
    # extend this as required
    raise Puppet::ParseError, "Foreman: Invalid filter_result: #{filter_result}, must not be boolean true" if filter_result == true

    begin
      path = URI.escape("/api/#{item}?search=#{search}&per_page=#{per_page}")

      req = Net::HTTP::Get.new(path)
      req['Content-Type'] = 'application/json'
      req['Accept'] = 'application/json'

      if use_tfmproxy
        configfile = '/etc/foreman-proxy/settings.yml'
        configfile = use_tfmproxy if use_tfmproxy.is_a? String
        raise Puppet::ParseError, "File #{configfile} not found while use_tfmproxy is enabled" unless File.exists?(configfile)
        tfmproxy = YAML.load(File.read(configfile))
        uri = URI.parse(tfmproxy[:foreman_url])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.ca_file = tfmproxy[:foreman_ssl_ca]
        http.cert = OpenSSL::X509::Certificate.new(File.read(tfmproxy[:foreman_ssl_cert]))
        http.key = OpenSSL::PKey::RSA.new(File.read(tfmproxy[:foreman_ssl_key]), nil)
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      else
        uri = URI.parse(foreman_url)
        http = Net::HTTP.new(uri.host, uri.port)
        req.basic_auth(foreman_user, foreman_pass)
        http.use_ssl = true if uri.scheme == 'https'
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?
      end
      results = Timeout::timeout(timeout) { PSON.parse http.request(req).body }
    rescue Exception => e
      raise Puppet::ParseError, "Failed to contact Foreman at #{foreman_url}: #{e}"
    end

    # Filter results
    if filter_result != false and results.has_key?('results')
      filtered_results = Array.new

      if filter_result.is_a? String
        # filter into an array
        results['results'].each do |result|
          if result.has_key?(filter_result)
            filtered_results << result[filter_result]
          end
        end
      elsif filter_result.is_a? Array
        # filter into an array of hashes by given key
        results['results'].each do |result|
          resulthash = Hash.new
          result.each do |key,value|
            if filter_result.include? key
              resulthash[key] = result[key]
            end
          end
          if resulthash != {}
            filtered_results << resulthash
          end
        end
      else
        # filter into an array of hashes while rename keys
        results['results'].each do |result|
          resulthash = Hash.new
          result.each do |key,value|
            if filter_result.include? key
              resulthash[filter_result[key]] = result[key]
            end
          end
          if resulthash != {}
            filtered_results << resulthash
          end
        end
      end
     return filtered_results
    end

    # return unfiltered
    return results
  end
end
