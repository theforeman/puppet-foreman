# Install an apt repo
define foreman::repos::apt ($repo) {

  include ::apt

  Apt::Source {
    location => 'http://deb.theforeman.org/',
    key      => 'AE0AF310E2EA96B6B6F4BD726F8600B9563278F6',
    include  => {
      src => false,
    },
  }

  ::apt::source { $name:
    repos => $repo,
  }

  ::apt::source { "${name}-plugins":
    release => 'plugins',
    repos   => $repo,
  }

}
