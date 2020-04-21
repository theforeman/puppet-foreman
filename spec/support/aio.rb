# This enforces the AIO Ruby sitedir
add_custom_fact :ruby, ->(os, facts) do
  # Non-AIO platforms
  return if ['Archlinux', 'FreeBSD', 'DragonFly', 'Windows'].include?(facts[:os]['family'])
  return unless facts[:ruby]

  version = facts[:ruby]['version'].match(/^(\d+\.\d+)/)[1]
  facts[:ruby].merge(sitedir: "/opt/puppetlabs/puppet/lib/ruby/site_ruby/#{version}.0")
end
