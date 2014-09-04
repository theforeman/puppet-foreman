Puppet::Type.type(:foreman_config_entry).provide(:cli) do

  desc "foreman_config_entry's CLI provider"

  confine :exists => '/usr/share/foreman/script/foreman-config'

  mk_resource_methods

  def self.run_foreman_config(args = "", options = {})
    Dir.chdir('/usr/share/foreman') do
      output = Puppet::Util::Execution.execute(
        "/usr/share/foreman/script/foreman-config #{args}",
        { :failonfail      => false,
          :combine         => false,
          :uid             => 'foreman',
          :gid             => 'foreman' }.merge(options)
      )
      if $?.success?
        output
      end
    end
  end

  def run_foreman_config(*args)
    self.class.run_foreman_config(*args)
  end

  def self.instances
    output = run_foreman_config
    return if output.nil?
    output.split("\n").map do |line|
        name, value = line.split(':')
        new(
          :name  => name,
          :value => value.strip
        ) unless value.nil?
    end.compact
  end

  def self.prefetch(resources)
    entries = instances
    return if entries.nil?
    resources.each do |name, resource|
      provider = entries.find { |entry| entry.name == name }
      if provider.nil? && resource[:ignore_missing]
        # just consider it has a value we exepcted
        provider = new(:name => name, :value => resource[:value])
      end
      resources[name].provider = provider
    end
  end

  def value
    if @property_hash[:value].nil?
      value = run_foreman_config("-k '#{name}'").to_s.chomp
      if value.empty? && resource[:ignore_missing]
        @property_hash[:value] = resource[:value]
      else
        @property_hash[:value] = value
      end
    else
      @property_hash[:value]
    end
  end

  def value=(value)
    return if dry
    run_foreman_config("-k '#{name}' -v '#{value}'", :combine => true, :failonfail => true)
    @property_hash[:value] = value
  end

end
