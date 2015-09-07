# = Foreman Katello plugin
#
# This class installs katello plugin
#
# === Parameters:
#
# $package::                              Package name to install
#
# $configure_katello_repo::               Enable yum repo with packages needed for katello,
#                                         type:boolean
#
# $katello_repo_version::                 The version of katello repo to install
#
# $rest_client_timeout::                  It sets both read and open HTTP timeouts.
#
# $post_sync_url::                        The shared secret for pulp notifying katello about
#                                         completed syncs
#
# $elastic_index::                        Name of the index in elasticsearch where to save data
#
# $elastic_url::                          Url of elasticsearch server
#
# $candlepin_url::                        Url of candlepin
#
# $candlepin_oauth_key::                  The oauth key for talking to the candlepin API;
#                                         default 'katello'
#
# $candlepin_oauth_secret::               The oauth secret for talking to the candlepin API;
#
# $pulp_url::                             Url of pulp server
#
# $pulp_oauth_key::                       The oauth key for talking to the pulp API;
#                                         default 'pulp'
#
# $pulp_oauth_secret::                    The oauth secret for talking to the pulp API;
#
# $qpid_url::                             Url of qpid server
#
# $qpid_subscriptions_queue_address::     Qpid queue address
#
# $loggers_glue::                         Enable glue logging
#
# $loggers_pulp_rest::                    Enable pulp logging
#
# $loggers_cp_rest::                      Enable cp_rest logging
#
# $loggers_cp_proxy::                     Enable cp_proxy logging
#
# $loggers_action::                       Enable action logging
#
# $loggers_tire_rest::                    Enable tire_rest logging
#
# $loggers_manifest_import_logger::       Enable manifest_import_logger logging
#
class foreman::plugin::katello (
  $package                          = $::foreman::plugin::katello::params::package,
  $configure_katello_repo           = $::foreman::plugin::katello::params::configure_katello_repo,
  $katello_repo_version             = $::foreman::plugin::katello::params::katello_repo_version,
  $rest_client_timeout              = $::foreman::plugin::katello::params::rest_client_timeout,
  $post_sync_url                    = $::foreman::plugin::katello::params::post_sync_url,
  $elastic_index                    = $::foreman::plugin::katello::params::elastic_index,
  $elastic_url                      = $::foreman::plugin::katello::params::elastic_url,
  $candlepin_url                    = $::foreman::plugin::katello::params::candlepin_url,
  $candlepin_oauth_key              = $::foreman::plugin::katello::params::candlepin_oauth_key,
  $candlepin_oauth_secret           = $::foreman::plugin::katello::params::candlepin_oauth_secret,
  $pulp_url                         = $::foreman::plugin::katello::params::pulp_url,
  $pulp_oauth_key                   = $::foreman::plugin::katello::params::pulp_oauth_key,
  $pulp_oauth_secret                = $::foreman::plugin::katello::params::pulp_oauth_secret,
  $qpid_url                         = $::foreman::plugin::katello::params::qpid_url,
  $qpid_subscriptions_queue_address = $::foreman::plugin::katello::params::qpid_subscriptions_queue_address,
  $loggers_glue                     = $::foreman::plugin::katello::params::loggers_glue,
  $loggers_pulp_rest                = $::foreman::plugin::katello::params::loggers_pulp_rest,
  $loggers_cp_rest                  = $::foreman::plugin::katello::params::loggers_cp_rest,
  $loggers_cp_proxy                 = $::foreman::plugin::katello::params::loggers_cp_proxy,
  $loggers_action                   = $::foreman::plugin::katello::params::loggers_action,
  $loggers_tire_rest                = $::foreman::plugin::katello::params::loggers_tire_rest,
  $loggers_manifest_import_logger   = $::foreman::plugin::katello::params::loggers_manifest_import_logger,
) inherits foreman::plugin::katello::params {
  validate_integer($rest_client_timeout)
  validate_string($post_sync_url)
  validate_string($elastic_index)
  validate_string($elastic_url)
  validate_string($candlepin_url)
  validate_string($candlepin_oauth_key)
  validate_string($candlepin_oauth_secret)
  validate_string($pulp_url)
  validate_string($pulp_oauth_key)
  validate_string($pulp_oauth_secret)
  validate_string($qpid_url)
  validate_string($qpid_subscriptions_queue_address)
  validate_bool($loggers_glue)
  validate_bool($loggers_pulp_rest)
  validate_bool($loggers_cp_rest)
  validate_bool($loggers_cp_proxy)
  validate_bool($loggers_action)
  validate_bool($loggers_tire_rest)
  validate_bool($loggers_manifest_import_logger)

  if $configure_katello_repo {
    case $::osfamily {
      'RedHat' : {
        if $::operatingsystemmajrelease == undef {
          $versions_array = split($::operatingsystemrelease, '\.') # facter 1.6
          $major = $versions_array[0]
        } else {
          $major = $::operatingsystemmajrelease # facter 1.7+
        }

        yumrepo { 'katello':
          enabled  => 1,
          gpgcheck => 0,
          baseurl  => "https://fedorapeople.org/groups/katello/releases/yum/${katello_repo_version}/katello/RHEL/${major}Server/x86_64/",
          before   => [Foreman::Plugin['katello']],
        }
      }
      default  : {
        fail("Unsupported osfamily ${::osfamily}")
      }
    }
  }

  include ::foreman::plugin::tasks

  foreman::config::passenger::fragment { 'katello':
    content     => template("${module_name}/plugins/katello_httpd.erb"),
    ssl_content => template("${module_name}/plugins/katello_httpd.erb"),
  }

  foreman::plugin { 'katello':
    package     => $package,
    config_file => '/etc/foreman/plugins/katello.yaml',
    config      => template("${module_name}/plugins/katello.yaml.erb"),
  }
}
