# Configure the foreman repo
class foreman::repo(
  $custom_repo = $::foreman::custom_repo,
  $repo        = $::foreman::repo,
  $gpgcheck    = $::foreman::gpgcheck
) {
  anchor { 'foreman::repo::begin': }

  if ! $custom_repo {
    Anchor['foreman::repo::begin'] ->
    foreman::repos { 'foreman':
      repo     => $repo,
      gpgcheck => $gpgcheck,
    } -> Class['::foreman::repos::extra']
  }

  Anchor['foreman::repo::begin'] ->
  class { '::foreman::repos::extra': } ->
  anchor { 'foreman::repo::end': }
}
