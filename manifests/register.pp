# @summary Register the host as Foreman
# @api private
class foreman::register (
  Stdlib::Fqdn $foreman_host_name = $facts['networking']['fqdn'],
) {
  foreman_host { "foreman-${$foreman_host_name}":
    ensure          => present,
    hostname        => $foreman_host_name,
    base_url        => $foreman::foreman_url,
    consumer_key    => $foreman::oauth_consumer_key,
    consumer_secret => $foreman::oauth_consumer_secret,
    effective_user  => $foreman::oauth_effective_user,
    ssl_ca          => $foreman::server_ssl_chain,
    facts           => $facts,
  }

  foreman_instance_host { "foreman-${$foreman_host_name}":
    ensure          => present,
    hostname        => $foreman_host_name,
    base_url        => $foreman::foreman_url,
    consumer_key    => $foreman::oauth_consumer_key,
    consumer_secret => $foreman::oauth_consumer_secret,
    effective_user  => $foreman::oauth_effective_user,
    ssl_ca          => $foreman::server_ssl_chain,
  }
}
