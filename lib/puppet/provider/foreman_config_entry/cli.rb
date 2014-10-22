Puppet::Type.type(:foreman_config_entry).provide(:cli) do

  desc "foreman_config_entry's CLI provider"

  confine :exists => '/usr/share/foreman/script/foreman-config'

  mk_resource_methods

  def self.instances
    Dir.chdir('/usr/share/foreman') do
      Puppet::Util::Execution.execute(
        '/usr/share/foreman/script/foreman-config',
        :failonfail      => true,
        :combine         => true,
        :uid             => 'foreman',
        :gid             => 'foreman'
      ).split("\n").map do |line|
        name, value = line.split(':')
        new(
          :name  => name,
          :value => value.strip
        ) unless value.nil?
      end.compact
    end
  end

  def self.prefetch(resources)
    entries = instances
    resources.keys.each do |name|
      if provider = entries.find{ |entry| entry.name == name }
        resources[name].provider = provider
      end
    end
  end

  def value=(value)
    Dir.chdir('/usr/share/foreman') do
      Puppet::Util::Execution.execute(
        "/usr/share/foreman/script/foreman-config -k '#{name}' -v '#{value}'",
        :failonfail      => true,
        :combine         => true,
        :uid             => 'foreman',
        :gid             => 'foreman'
      )
    end
    @property_hash[:value] = value
  end

end
