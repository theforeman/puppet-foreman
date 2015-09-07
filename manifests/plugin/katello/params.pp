# Default parameters for foreman::plugin::katello
class foreman::plugin::katello::params {
  $package = 'ruby193-rubygem-katello'
  $configure_katello_repo = $::osfamily == 'RedHat'
  $katello_repo_version = '2.3'

  $rest_client_timeout = 120
  $post_sync_token = cache_data('post_sync_token', random_password(32))
  $post_sync_url = "https://${::fqdn}/katello/api/v2/repositories/sync_complete?token=${post_sync_token}"

  $elastic_index = 'katello'
  $elastic_url = "http://${::fqdn}:9200"

  $candlepin_url = "https://${::fqdn}:8443/candlepin"
  $candlepin_oauth_key = 'katello'
  $candlepin_oauth_secret = 'secret'

  $pulp_url = "https://${::fqdn}/pulp/api/v2/"
  $pulp_oauth_key = 'pulp'
  $pulp_oauth_secret = 'secret'

  $qpid_url = 'amqp:ssl:localhost:5671'
  $qpid_subscriptions_queue_address = 'katello_event_queue'

  $loggers_glue = true
  $loggers_pulp_rest = true
  $loggers_cp_rest = true
  $loggers_cp_proxy = true
  $loggers_action = true
  $loggers_tire_rest = false
  $loggers_manifest_import_logger = true
}
