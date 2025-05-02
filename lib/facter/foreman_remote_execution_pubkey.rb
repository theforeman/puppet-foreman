Facter.add(:foreman_remote_execution_pubkey) do
  pubkey = '/var/lib/foreman-proxy/ssh/id_rsa_foreman_proxy.pub'
  confine do
    File.exists?(pubkey)
  end
  setcode do
    File.read(pubkey).strip
  end
end
