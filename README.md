[![Puppet Forge](http://img.shields.io/puppetforge/v/theforeman/foreman.svg)](https://forge.puppetlabs.com/theforeman/foreman)
[![Build Status](https://travis-ci.org/theforeman/puppet-foreman.svg?branch=master)](https://travis-ci.org/theforeman/puppet-foreman)

# Puppet module for managing Foreman

Installs and configures [Foreman](http://theforeman.org), part of the [Foreman
installer](http://github.com/theforeman/foreman-installer) or to be used as a
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
on the host this module is applied to. If using MySQL, the puppetlabs-mysql
module must be added to the modulepath, otherwise it's not required.

## Support policy

At any time, the module supports two releases, however the previous version
may require parameters to be changed from their default values. These should
be noted below.

Thus 'master' will support the upcoming major version and the current stable.
The latest release (git tag, Puppet Forge) should support current and the
previous stable release.

### Foreman 1.8/1.9 compatibility notes

On EL or Amazon, set:

    passenger_ruby         => '/usr/bin/ruby193-ruby',
    passenger_ruby_package => 'ruby193-rubygem-passenger-native',
    plugin_prefix          => 'ruby193-rubygem-foreman_',

If using `foreman::plugin::ovirt_provision`, puppetdb or tasks, also set the
`package` parameter as appropriate to:

    ruby193-rubygem-foreman-tasks
    ruby193-rubygem-ovirt_provision_plugin
    ruby193-rubygem-puppetdb_foreman

### Foreman 1.7 compatibility notes

* set `apipie_task => 'apipie:cache'` as Foreman 1.7 packages didn't have
  precompiled API docs
* `foreman::compute::ec2` needs `package => 'foreman-compute'` on Foreman 1.7,
  as the package has been renamed in newer versions.

# Contributing

* Fork the project
* Commit and push until you are happy with your contribution
* Send a pull request with a description of your changes

See the CONTRIBUTING.md file for much more information.

Adding new `foreman::plugin::*` classes is a very useful place to start
contributing to this module.

# More info

See http://theforeman.org or at #theforeman irc channel on freenode

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
along with this program.  If not, see <http://www.gnu.org/licenses/>.
