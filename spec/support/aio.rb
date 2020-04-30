add_custom_fact :aio_agent_version, ->(os, facts) do
  return facts[:puppetversion] unless ['Archlinux', 'FreeBSD', 'DragonFly', 'Windows'].include?(facts[:os]['family'])
end
