# Changelog

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
