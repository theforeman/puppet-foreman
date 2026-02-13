# @summary Register the host as Foreman
# @api private
class foreman::register (
  Stdlib::Fqdn $foreman_host_name = $facts['networking']['fqdn'],
  Boolean $force_fact_upload = false,
) {
  foreman_host { "foreman-${$foreman_host_name}":
    ensure            => present,
    hostname          => $foreman_host_name,
    base_url          => $foreman::foreman_url,
    consumer_key      => $foreman::oauth_consumer_key,
    consumer_secret   => $foreman::oauth_consumer_secret,
    effective_user    => $foreman::oauth_effective_user,
    ssl_ca            => $foreman::server_ssl_chain,
    facts             => $facts,
    force_fact_upload => $force_fact_upload,
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

  # Ensure Foreman proxy is started before registering the Foreman host
  # as some plugins want to talk to the proxy when modifying the host object
  # By using collectors, we don't have to test if the collected resource actually exists
  Service <| title == 'foreman-proxy' |> -> Foreman_host["foreman-${$foreman_host_name}"]
}
