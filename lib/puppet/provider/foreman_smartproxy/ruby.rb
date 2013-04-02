begin
  ENV['RAILS_ENV'] = 'production'
  require File.expand_path('config/boot', '/usr/share/foreman')
  require File.expand_path('config/application', '/usr/share/foreman')
  Rails.application.require_environment!
rescue LoadError
end

Puppet::Type.type(:foreman_smartproxy).provide(:ruby) do

  def self.instances
    resources = []
    begin
      SmartProxy.all.each do |proxy|
        resources << new(
          :name   => proxy[:name],
          :ensure => :present,
          :url    => proxy[:url]
        )
      end
    rescue => e
      raise "Could not get smartproxies from Foreman: #{e}"
    end
    resources
  end

  def self.prefetch(resources)
    proxies = instances
    resources.keys.each do |name|
      if provider = proxies.find{ |p| p.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present 
  end

  def create
    proxy = SmartProxy.new(
      :name => resource[:name],
      :url  => resource[:url]
    )
    old_current = User.current
    User.current = User.admin
    proxy.save!
  ensure
    User.current = old_current
  end

  def destroy
    @property_hash[:ensure] = :absent
    old_current = User.current
    User.current = User.admin
    SmartProxy.find_by_name(@property_hash[:name]).destroy
  ensure
    User.current = old_current
  end

  def url
    @property_hash[:url]
  end

  def url=(value)
    @property_hash[:url] = value
    proxy = SmartProxy.find_by_name(@property_hash[:name])
    proxy.update_attribute :url, value
    old_current = User.current
    User.current = User.admin
    proxy.save!
  ensure
    User.current = old_current
  end

end

