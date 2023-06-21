[![Puppet Forge](https://img.shields.io/puppetforge/v/theforeman/foreman.svg)](https://forge.puppetlabs.com/theforeman/foreman)
[![Build Status](https://travis-ci.org/theforeman/puppet-foreman.svg?branch=master)](https://travis-ci.org/theforeman/puppet-foreman)

# Puppet module for managing Foreman

Installs and configures [Foreman](https://theforeman.org), part of the [Foreman
installer](https://github.com/theforeman/foreman-installer) or to be used as a
Puppet module.

Many Foreman plugins can be installed by adding additional `foreman::plugin::*`
classes, extra compute resource support via `foreman::compute::*` classes and
the Hammer CLI can be installed by adding `foreman::cli`.

By default, it configures Foreman to run as a standalone service fronted by
Apache as a reverse proxy with a PostgreSQL database.

The web interface is configured to use Puppet's SSL certificates by default, so
ensure they're present first, reconfigure `server_ssl_*` or disable the `ssl`
parameter. When used with the 'puppet' module, it will generate a new CA and
the required certificate.

Lots of parameters are supplied to tune the default installation, which may be
found in the class documentation at the top of each manifest.

Other modules may be used in combination with this one: [puppet](https://github.com/theforeman/puppet-puppet)
for managing a Puppet master and agent, and [foreman_proxy](https://github.com/theforeman/puppet-foreman_proxy)
to configure Foreman's Smart Proxy and related services.

## Database support

The default database is PostgreSQL, which will be fully installed and managed
on the host this module is applied to. Databases will be created with using the
`en_US.utf8` locale, which means a respective OS locale must be available on
the database host. The database management can be disabled with `db_manage`.

## Rails Cache support

Foreman supports different backends as Rails cache. This is handled by this
module using the parameter `rails_cache_store`. The parameter takes a hash
containing the type and options specfic to the backend.

The default is the file backend, configured via `{'type' => 'file'}`. To
setup for redis use a hash similar to `{'type' => 'redis', 'urls' => ['localhost:8479/4'], 'options' => {'compress' => 'true', 'namespace' => 'foreman'}}`
where `urls` takes an array of redis urls which get prepended with `redis://`
and `options` using a hash with options from [rails](https://guides.rubyonrails.org/caching_with_rails.html#activesupport-cache-store)
falling back to `{'compress' => 'true', 'namespace' => 'foreman'}` if no
option is provided.

An example configuration for activating the redis backend with a local instance
could look like this:

```puppet
class { 'foreman':
  rails_cache_store => {
    'type' => 'redis',
    'urls' => ['localhost:8479/4'],
    'options' => {
      'compress' => 'true',
      'namespace' => 'foreman'
    }
  }
}
```

## Support policy

At any time, the module supports two releases, however the previous version
may require parameters to be changed from their default values. These should
be noted below.

Thus 'master' will support the upcoming major version and the current stable.
The latest release (git tag, Puppet Forge) should support current and the
previous stable release.

### Foreman version compatibility notes

This module targets Foreman 3.1+.
The module can not be used to manage Foreman installations on EL7.

This module configures Apache to serve static assets from
`/var/lib/foreman/public` directly. This requires an appropriate
SELinux policy, like the one introduced in [`foreman-selinux`
version 3.5](https://projects.theforeman.org/issues/35402).
Additionally, some plugin packages might be incomplatible with such
a deployment. To serve assets via Rails again, set
`foreman::config::apache::proxy_assets` to `true`.

## Types and providers

`foreman_config_entry` can be used to manage settings in Foreman's database, as
seen in _Administer > Settings_. The `cli` provider uses `foreman-rake` to change settings.

`foreman_smartproxy` can create and manage registered smart proxies in
Foreman's database. The `rest_v3` provider uses the API with Ruby's HTTP library, OAuth and JSON.

`foreman_hostgroup` can be used to create and destroy hostgroups. Nested hostgroups are supported
and hostgroups can be assigned to locations/organizations.
The type currently doesn't support other properties such as `environment`, `puppet classes` etc.

## Foreman ENC via hiera

There is a function `foreman::enc` to retrieve the ENC data. This returns the
data as a hash and can be used in Hiera. This requires the URL to use the
Puppet CA infrastructure:

```yaml
---
version: 5
hierarchy:
  - name: "Foreman ENC"
    data_hash: foreman::enc
    options:
      url: https://foreman.example.com
```

It is also possible to use HTTP basic auth by adding a username/password to the
URL in the form of `https://username:password@foreman.example.com`.

Then within your manifests you can use `lookup`. For example, in
`manifests/site.pp`:

```puppet
node default {
  lookup('classes', {merge => unique}).include
}
```

# Contributing

* Fork the project
* Commit and push until you are happy with your contribution
* Send a pull request with a description of your changes

See the CONTRIBUTING.md file for much more information.

Adding new `foreman::plugin::*` classes is a very useful place to start
contributing to this module.

# More info

See https://theforeman.org or at #theforeman irc channel on freenode

Copyright (c) 2010-2013 Ohad Levy and their respective owners

Except where specified in provided modules, this program and entire
repository is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
