require 'voxpupuli/acceptance/spec_helper_acceptance'

ENV['BEAKER_setfile'] ||= 'centos8-64{hostname=centos8-64.example.com}'

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
end

Dir["./spec/support/acceptance/**/*.rb"].sort.each { |f| require f }
