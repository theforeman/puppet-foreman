require 'fileutils'
require 'yaml'
require 'etc'

# Retrieves data from a cache file, or creates it with supplied data if the file doesn't exist
#
# Useful for having data that's randomly generated once on the master side (e.g. a password), but
# then stays the same on subsequent runs.
#
# Usage: cache_data(name, initial_data)
# Example: $password = cache_data("mysql_password", random_password(32))
module Puppet::Parser::Functions
  newfunction(:cache_data, :type => :rvalue) do |args|
    raise Puppet::ParseError, 'Usage: cache_data(name, initial_data)' unless args.size == 2

    name = args[0]
    raise Puppet::ParseError, 'Must provide data name' unless name
    initial_data = args[1]

    cache_dir = File.join(Puppet[:vardir], 'foreman_cache_data')
    cache = File.join(cache_dir, name)
    if File.exists? cache
      YAML.load(File.read(cache))
    else
      FileUtils.mkdir_p cache_dir unless File.exists? cache_dir
      File.open(cache, 'w', 0600) do |c|
        c.write(YAML.dump(initial_data))
      end
      # Chown to puppet to prevent later cache-read errors when this is run as root
      if Etc.getpwuid.name == 'root' && (uid = (Etc.getpwnam('puppet').uid rescue nil))
        File.chown(uid, nil, cache)
        File.chown(uid, nil, cache_dir)
      end
      initial_data
    end
  end
end
