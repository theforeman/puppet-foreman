begin
  require 'augeas'

  module Facter::Util::Sssd
    def self.aug_value(lens, file, path)
      Augeas::open(nil, nil, Augeas::NO_MODL_AUTOLOAD) do |aug|
        aug.transform(:lens => lens, :incl => file)
        aug.load
        aug.set('/augeas/context', "/files#{file}")
        aug.get(path)
      end
    end

    def self.sssd_value(path)
      val = aug_value('Sssd.lns', '/etc/sssd/sssd.conf', path)
      val.split(',').map(&:strip) if val
    end
  end
rescue LoadError => e
  Facter.debug("Cannot load Augeas library for custom facts: #{e}")
end
