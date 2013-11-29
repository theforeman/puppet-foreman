# Puppet module for managing Foreman

Installs and configures Foreman.

Part of the Foreman installer: http://github.com/theforeman/foreman-installer

## ENC / Report Processors

The current enc and report processor scripts are only compatible with Foreman 1.3.
To get the old scripts, pass the appropriate API variables to `foreman::puppetmaster`

    class { 'foreman::puppetmaster':
      enc_api    => 'v1',
      report_api => 'v1',
    }

## Database support

This module supports configuration of either SQLite, PostgreSQL or MySQL as the
database for Foreman.  The database type can be changed using the `db_type`
parameter, or management disabled with `db_manage`.

The default database is PostgreSQL, which will be fully installed and managed
on the host this module is applied to.  If using MySQL, the puppetlabs-mysql
module must be added to the modulepath, otherwise it's not required.

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
