def purge_foreman
  case fact('osfamily')
  when 'RedHat'
    on default, 'yum -y remove foreman* tfm-*'
  when 'Debian'
    on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
    on default, 'apt-get purge -y ruby-hammer-cli-*', { :acceptable_exit_codes => [0, 100] }
  end

  apache_service_name = ['debian', 'ubuntu'].include?(os[:family]) ? 'apache2' : 'httpd'
  on default, "systemctl stop #{apache_service_name}", { :acceptable_exit_codes => [0, 5] }
end
