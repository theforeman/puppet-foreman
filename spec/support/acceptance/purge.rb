def purge_foreman
  case fact('osfamily')
  when 'RedHat'
    on default, 'rm -f /etc/dnf/protected.d/grub2-tools-minimal.conf'
    on default, 'yum -y remove foreman*'
  when 'Debian'
    on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
    on default, 'apt-get purge -y ruby-hammer-cli-*', { :acceptable_exit_codes => [0, 100] }
  end

  apache_service_name = ['debian', 'ubuntu'].include?(os[:family]) ? 'apache2' : 'httpd'
  on default, "systemctl stop #{apache_service_name} dynflow-sidekiq@* foreman foreman-proxy", { :acceptable_exit_codes => [0, 5] }
  on default, 'runuser - postgres -c "dropdb foreman"', { :acceptable_exit_codes => [0, 1, 127] }
end
