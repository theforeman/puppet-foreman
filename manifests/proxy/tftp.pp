class foreman::proxy::tftp {
  include tftp

  $syslinux_root  = "/usr/lib/syslinux"
  $syslinux_files = ["pxelinux.0","menu.c32","chain.c32"]
  $tftproot       = "/var/lib/tftpboot"
  $tftp_dir       = ["${tftproot}/pxelinux.cfg","${tftproot}/build"]

  file{
    $tftproot:
      ensure => directory;
    $tftp_dir:
      owner => $foreman_proxy_user,
      mode  => 644,
      require => Package["foreman-proxy"],
      ensure => directory,
      recurse => true;
  }

  link_file{$syslinux_files:
    source_path => $syslinux_root,
    target_path => $tftproot,
  }
}
