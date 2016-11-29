begin
  ENV["RAILS_ENV"] = 'production'
  require File.expand_path("config/boot", '/usr/share/foreman')
  require File.expand_path("config/application", '/usr/share/foreman')
  Rails.application.require_environment!
rescue LoadError
end

Puppet::Type.type(:foreman_user).provide(:ruby) do

  def self.instances
    resources = []
    begin
      User.all.each do |user|
        resources << new(
          :name          => user[:login],
          :ensure        => :present,
          :login         => user[:login],
          :admin         => user[:admin] ? :true : :false,
          :firstname     => user[:firstname],
          :lastname      => user[:lastname],
          :mail          => user[:mail]
        )
      end
    rescue => e
      raise "Could not get users from Foreman: #{e}"
    end
    resources
  end

  def self.prefetch(resources)
    users = instances
    resources.keys.each do |name|
      if provider = users.find{ |u| u.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present 
  end

  def create
    user = User.new(
      :login       => resource[:login],
      :firstname   => resource[:firstname],
      :lastname    => resource[:lastname],
      :mail        => resource[:mail],
      :auth_source => AuthSourceInternal.first,
      :password    => resource[:password]
    )
    user.update_attribute :admin, resource[:admin]  == :true ? true : false
    old_current = User.current
    User.current = User.admin
    user.save!
  ensure
    User.current = old_current
  end

  def destroy
    @property_hash[:ensure] = :absent
    old_current = User.current
    User.current = User.admin
    User.find_by_login(@property_hash[:login]).destroy
  ensure
    User.current = old_current
  end

  def admin
    @property_hash[:admin]
  end

  def admin=(value)
    @property_hash[:admin] = value
    user = User.find_by_login(@property_hash[:login])
    user.update_attribute :admin, value == :true ? true : false
    old_current = User.current
    User.current = User.admin
    user.save!
  ensure
    User.current = old_current
  end

  def firstname
    @property_hash[:firstname]
  end

  def firstname=(value)
    @property_hash[:firstname] = value
    user = User.find_by_login(@property_hash[:login])
    user.update_attribute :firstname, value
    old_current = User.current
    User.current = User.admin
    user.save!
  ensure
    User.current = old_current
  end

  def lastname
    @property_hash[:lastname]
  end

  def lastname=(value)
    @property_hash[:lastname] = value
    user = User.find_by_login(@property_hash[:login])
    user.update_attribute :lastname, value
    old_current = User.current
    User.current = User.admin
    user.save!
  ensure
    User.current = old_current
  end

  def mail
    @property_hash[:mail]
  end

  def mail=(value)
    @property_hash[:mail] = value
    user = User.find_by_login(@property_hash[:login])
    user.update_attribute :mail, value
    old_current = User.current
    User.current = User.admin
    user.save!
  ensure
    User.current = old_current
  end

end
