define foreman::install::repos(
  $repo = stable,
  $gpgcheck = true
) {
  warning('foreman::install::repos is deprecated, use foreman::repos instead')

  foreman::repos { $name:
    repo     => $repo,
    gpgcheck => $gpgcheck,
  }
}
