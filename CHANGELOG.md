# Changelog

## 2.2.2
* Expose Apache vhost ServerName via servername parameter
* Fix dependency on TFTP directory in discovery image download
* Fix apipie-bindings cache directory when HOME is unset in daemon (#7063)
* Unit test and lint fixes

## 2.2.1
* Move ENC and report processor configuration to /etc/puppet/foreman.yaml

## 2.2.0
* Add ipa_authentication parameter to configure Foreman authentication against
  IPA using Kerberos etc (#6445)
* Add foreman::cli class to install and configure Hammer CLI
* Add admin_* parameters for initial admin username and password (Foreman 1.6)
* Add initial_* parameters to create an initial organization or location (#6802)
* Add foreman::plugin::tasks class to install foreman_tasks plugin
* install_images parameter added to foreman::plugin::discovery to download
  discovery images to TFTP root
* Change ENC and report processor configuration to /etc/foreman/puppet.yaml
  instead of embedded and templated settings
* Add foreman_smartproxy provider that uses apipie-bindings, adds a timeout
  parameter
* Configure websockets_ssl* in Foreman settings (#3601)
* Purge configuration files under Foreman httpd directories
* Extend startup timeout for Passenger, add parameters to control
* Refresh proxy features when foreman_smartproxy is notified (#3185)
* Fix future parser compatibility in random_password() and manifests
* Add Windows and SUSE to params class
* Remove v1 node and report processors
* Remove workaround for passenger.conf being replaced by pl-apache
* Refactor foreman::config::enc into foreman::puppetmaster

## 2.1.4
* Report processor: increment error counter for non-resource Puppet
  errors (#3851)

## 2.1.3
* Fix ordering of Apache and foreman_smartproxy resources
* Workaround Travis CI/REE issue

## 2.1.2
* Fix user shell path so it's valid on Debian (#5390)
* Remove obsolete test conditional for Facter 2 compat

## 2.1.1
* Fix SSL configuration with upper case hostnames (#4679)

## 2.1.0
* Add compute resource and new plugin classes (#3308)
* Add support for parallel fact pushes in node.rb
* Add event driven fact pushing (--watch-facts) in node.rb
* Add server_ssl_chain parameter to set SSLCertificateChainFile
* Add support for plugins to add virtual host entries
* Use alphanumeric ordering for vhosts (#4225)
* Use the production CentOS SCL repo, use centos-release-SCL
* Add Debian plugins repo
* Update to puppetlabs-apache 1.0
* Trigger db:seed too when DB changes
* Run foreman-rake apipie:cache after installation
* Ensure plugins are installed after core
* Improve node.rb response when server-side error occurs
* Remove template source from header for Puppet 3.5 compatibility
* Add basic Archlinux support for agent classes
* Fix Modulefile specification for Forge compatibility
* Cleanup of foreman::config

## 2.0.1
* Bump stdlib dependency to fix Forge upload error

## 2.0.0
* Add Foreman 1.4 support (default)
* Switch to puppetlabs-apache from theforeman-apache
* Switch to puppetlabs-postgresql version 3+
* Add foreman::plugin define and classes
* Set far-future expires headers for web UI assets
* Add db:seed support after db:migrate
* Add EPEL and SCL yum repository configuration
* Add $server_ssl_* parameters to configure vhost SSL certs
* Set PostgreSQL DB owner to foreman for db:drop support
* Create cache file properly to prevent re-sending of fact files (node.rb)
* Add support for running node.rb as a different user
* Skip empty host fact files (node.rb)
* Fix running DB migrations for SQLite
* Fix JSON package name on Debian 6 (Squeeze)
* Fix proxy registration under foreman_api 0.1.18+
* Only chown files in cache_data if puppet user exists
* Quote database passwords in database.yml
* Updated foreman() parser function instructions
* Move passenger restart to foreman::service class
* Drop Puppet 3.0 and 3.1 tests
* Update tests for rspec-puppet 1.0.0
