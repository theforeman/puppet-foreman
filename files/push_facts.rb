#! /usr/bin/env ruby
#
# This scripts runs on remote puppetmasters that you wish to import their nodes facts into Foreman
# it uploads all of the new facts its encounter based on a control file which is stored in /tmp directory.
# This script can run in cron, e.g. once every minute
# if you run it on many puppetmasters at the same time, you might consider adding something like:
# sleep rand(10) # that not all PM hammers the DB at once.
# ohadlevy@gmail.com

# puppet config dir
puppetdir="/var/lib/puppet"

# URL where Foreman lives
url="http://foreman"

# Temp file keeping the last run time
stat_file = "/tmp/foreman_fact_importer"

require 'fileutils'
require 'net/http'
require 'net/https'
require 'uri'

last_run = File.exists?(stat_file) ? File.stat(stat_file).mtime.utc : Time.now - 365*60*60

Dir["#{puppetdir}/yaml/facts/*.yaml"].each do |filename|
  last_fact = File.stat(filename).mtime.utc
  if last_fact > last_run
    fact = File.read(filename)
    puts "Importing #{filename}"
    begin
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https' then
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      req = Net::HTTP::Post.new("/fact_values/create?format=yml")
      req.set_form_data({'facts' => fact})
      response = http.request(req)
    rescue Exception => e
      raise "Could not send facts to Foreman: #{e}"
    end
  end
end
FileUtils.touch stat_file
