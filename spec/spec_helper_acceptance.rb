require 'voxpupuli/acceptance/spec_helper_acceptance'

ENV['BEAKER_setfile'] ||= 'centos7-64{hostname=centos7-64.example.com}'

configure_beaker(modules: :fixtures) do |host|
  if fact_on(host, 'os.family') == 'RedHat'
    unless fact_on(host, 'os.name') == 'Fedora'
      # don't delete downloaded rpm for use with BEAKER_provision=no +
      # BEAKER_destroy=no
      on host, 'sed -i "s/keepcache=.*/keepcache=1/" /etc/yum.conf'
    end
    # refresh check if cache needs refresh on next yum command
    on host, 'yum clean expire-cache'
  end

  # In Puppet 7 the locale ends up being C.UTF-8 if it isn't passed.
  # This locale doesn't exist in EL7 and won't be supported either.
  # At least PostgreSQL runs into this.
  if host['hypervisor'] == 'docker' && host['platform'] == 'el-7-x86_64'
    ENV['LANG'] = 'en_US.UTF-8'
  end
end

Dir["./spec/support/acceptance/**/*.rb"].sort.each { |f| require f }
