# Puppet module for managing Foreman

Installs and configures Foreman.

Part of the Foreman installer: http://github.com/theforeman/foreman-installer

## Database support

This module supports configuration of either SQLite, PostgreSQL or MySQL as the
database for Foreman.  The database type can be changed using the `db_type`
parameter, or management disabled with `db_manage`.

The default database is PostgreSQL, which will be fully installed and managed
on the host this module is applied to.  If using MySQL, the puppetlabs-mysql
module must be added to the modulepath, otherwise it's not required.

## Support policy

At any time, the module supports two releases, however the previous version
may require parameters to be changed from their default values.  These should
be noted below.

Thus 'master' will support the upcoming major version and the current stable.
The latest release (git tag, Puppet Forge) should support current and the
previous stable release.

## Foreman 1.6 support

On Ubuntu 12.04 with Foreman 1.6, the move to configure Ruby 1.9 with Brightbox
should be disabled:

    class { 'foreman':
      configure_brightbox_repo => false,
      passenger_ruby           => '',
      passenger_ruby_package   => '',
    }

# Contributing

* Fork the project
* Commit and push until you are happy with your contribution
* Send a pull request with a description of your changes

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
