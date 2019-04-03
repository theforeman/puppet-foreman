[![Puppet Forge](https://img.shields.io/puppetforge/v/theforeman/foreman.svg)](https://forge.puppetlabs.com/theforeman/foreman)
[![Build Status](https://travis-ci.org/theforeman/puppet-foreman.svg?branch=master)](https://travis-ci.org/theforeman/puppet-foreman)

# Puppet module for managing Foreman

Installs and configures [Foreman](https://theforeman.org), part of the [Foreman
installer](https://github.com/theforeman/foreman-installer) or to be used as a
Puppet module.

Many Foreman plugins can be installed by adding additional `foreman::plugin::*`
classes, extra compute resource support via `foreman::compute::*` classes and
the Hammer CLI can be installed by adding `foreman::cli`.

By default, it configures Foreman to run under Apache and Passenger plus
with a PostgreSQL database. A standalone service can be configured instead by
setting `passenger` to false, though this isn't recommended in production.

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

This module supports configuration of either SQLite, PostgreSQL or MySQL as the
database for Foreman. The database type can be changed using the `db_type`
parameter, or management disabled with `db_manage`.

The default database is PostgreSQL, which will be fully installed and managed
on the host this module is applied to. Databases will be created with using the
`en_US.utf8` locale, which means a respective OS locale must be available on
the database host. If using MySQL, the puppetlabs-mysql module must be added to
the modulepath, otherwise it's not required.

## Support policy

At any time, the module supports two releases, however the previous version
may require parameters to be changed from their default values. These should
be noted below.

Thus 'master' will support the upcoming major version and the current stable.
The latest release (git tag, Puppet Forge) should support current and the
previous stable release.

### Foreman version compatibility notes

Running without passenger is only supported on Foreman 1.22+.

The parameters `locations_enabled`, `organizations_enabled` and `authentication`
will only have any affect on Foreman 1.20 or older, in newer versions these
settings have been removed.

**Warning** Users configuring Foreman 1.20 and earlier will need to pay
particular attention. Some defaults have been flipped, including all user
authentication.

| Setting                    | module 11.x with 1.20 | module 10.x with 1.20 |
|----------------------------|-----------------------|-----------------------|
| `authentication` (`login`) | false                 | true                  |
| `locations_enabled`        | true                  | false                 |
| `organizations_enabled `   | true                  | false                 |

For Foreman 1.16 or older, please use the 9.x release series of this module.

## Running without passenger

To use this module without passenger, the `passenger` parameter must be set to
`false`. This will install the `foreman-service` package and ensure the service
is running.

This introduces a soft dependency on `camptocamp-systemd`. This feature is only
available on Foreman 1.22+.

## Types and providers

`foreman_config_entry` can be used to manage settings in Foreman's database, as
seen in _Administer > Settings_. Provides:

* `cli` provider uses `foreman-rake` to change settings (default)

`foreman_hostgroup` can create and manage host group in Foreman's database.
Providers:

* `rest_v2` provider uses API v2 with apipie-bindings and OAuth (default)

`foreman_smartproxy` can create and manage registered smart proxies in
Foreman's database. Providers:

* `rest_v3` provider uses API v2 with Ruby HTTP library, OAuth and JSON (default)
* `rest_v2` provider uses API v2 with apipie-bindings and OAuth

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
