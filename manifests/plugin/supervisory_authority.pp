# == Class: Foreman supervisory_authority Plugin
#
# This class installs the supervisory_authority plugin and configuration file.
#
# === Parameters:
#
# $server_url::            The URL for your APM Server. The URL must be fully qualified, including protocol (http or https) and port.
# 
# $secret_token::          This string is used to ensure that only your agents can send data to your APM server.
# 
# $service_name::          The name of your service. This is used to keep all the errors and transactions of your service together.
#
# === Advanced Parameters:
#
# $log_level::             Log severity level: 0 (debug), 1 (info), 2 (warn), 3 (error), 4 (fatal), 5 (unknown)
#
# $pool_size::             Size of Elastic APM thread pool to send its data to APM Server.
#
# $api_buffer_size::       Maximum amount of objects kept in queue, before sending to APM Server.
# 
# $api_request_size::      Maximum amount of bytes sent over one request to APM Server.
#
# $api_request_time::      Maximum duration of a single streaming request to APM Server before opening a new one.
#
# $transaction_max_spans:: Limits the amount of spans that are recorded per transaction.
#
# $http_compression::      Defines if http compression is used to send data to APM Server.
#
# $metrics_interval::      Specify the interval for reporting metrics to APM Server.
#
class foreman::plugin::supervisory_authority (
  Stdlib::HTTPUrl              $server_url,
  String                       $secret_token,
  Pattern[/^[a-zA-Z0-9 _-]+$/] $service_name,
  Integer[0,5]                 $log_level             = 1,
  Integer[0]                   $pool_size             = 1,
  Integer[0]                   $api_buffer_size       = 256,
  String                       $api_request_size      = '750kb',
  String                       $api_request_time      = '10s',
  Integer[0]                   $transaction_max_spans = 500,
  Boolean                      $http_compression      = false,
  String                       $metrics_interval      = '30s',
) {
  foreman::plugin { 'supervisory_authority':
    config => template('foreman/foreman_supervisory_authority.yaml.erb'),
  }
}
