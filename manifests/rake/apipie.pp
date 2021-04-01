# @summary a rake task to ensure a correct apipie cache
# @api private
class foreman::rake::apipie {
  foreman::rake { 'apipie:cache:index':
    timeout => 0,
    require => Class['foreman::config'],
    before  => Class['foreman::database'],
  }
}
