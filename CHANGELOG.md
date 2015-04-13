# Changelog

## 3.0.2
* Fix default foreman::plugin::openscap parameter values
* foreman_config_entry: ensure HOME is set on all Puppet versions
* foreman_config_entry: change foreman-config to foreman-rake
* spec fixes for concat_native changes

## 3.0.1
* Fix support for mysql by removing inclusion of mysql class which was removed
  by puppetlabs/mysql in version 3.0.0
* Fix foreman_config_entry checking of dry parameter

## 3.0.0
* New classes to install Foreman plugins:
    * foreman::plugin::abrt to install ABRT support
    * foreman::plugin::digitalocean for DigitalOcean compute resources
    * foreman::plugin::docker for Docker container management
    * foreman::plugin::openscap to install OpenSCAP support
    * foreman::plugin::salt for Salt management support
* New or changed parameters:
    * Add db_pool parameter to control database connection pool size
    * Add manage_user parameter to disable 'foreman' user resource
    * Add server_ssl_crl parameter to change SSL CRL used
    * Add apipie_task parameter for Foreman 1.7 compatibility
    * Add puppet_user/group parameters to foreman::puppetmaster
    * Add timeout parameter to foreman::puppetmaster, increase timeout from
      10 to 60 seconds
    * Add config/config_file parameters to foreman::plugin
    * Add package parameter to foreman::compute::ec2 for Foreman 1.7
      compatibility
    * Rename facts parameter to receive_facts, due to trusted variables
      conflict, an incompatible change (#8944)
    * Changes to foreman::plugin::discovery parameters
    * Remove deprecated passenger_scl parameter, use passenger_ruby and
      passenger_ruby_package instead
* Other features:
    * Add support for Discovery Image 2.0 deployment
    * Add support to deploy Foreman on sub-URI with Passenger by changing
      the foreman_url parameter
    * Configure foreman-plugins repo, remove unused 'rc' repo support (#8880)
    * Enable SSL CRL checking to Foreman virtual host
    * Add additional resource types to foreman() search function (#9155)
* Other changes and fixes:
    * Use pending DB migration/seed flags in Foreman to re-run DB tasks when
      they fail on subsequent runs, requiring Foreman 1.7+ (#4611, #7353)
    * Use puppetlabs/apache 1.2.0 features
    * Improve ENC encoding handling to fix facts uploads from Windows
    * Improve tests with rspec-puppet-facts
    * Improvements for Puppet 4 and future parser support
    * Refreshed README
    * Fix apt-key installation from refreshonly to unless clause
    * Fix dependency on LSB facts (#9449)
    * Fix custom facts error when trying to load ruby-augeas
    * Fix class parameters documentation display in foreman-installer (#6904)
    * Fix mod_lookup_identity concatentation of multiple email addresses
    * Fix hard references to theforeman/puppet in foreman::puppetmaster
    * Fix foreman.yaml path in report processor comment
    * Fix minimum adrien/alternatives version to released 0.3.0
    * Fix spelling error in configure_scl_repo description
    * Fix metadata.json quality issues, pinning dependencies

## 2.3.2
* Refresh db:migrate if DB class changes (#9101)

## 2.3.1
* Ensure Foreman DB settings are initialised before Apache starts to prevent
  race condition (#4611, #7353)
* Remove timeout on apipie:cache rake task (#8381)
* Fix puppetdb_foreman Debian package name

## 2.3.0
* Add foreman_config_entry resource type and provider
* Configure Brightbox Ruby NG PPA on Ubuntu 12.04 (#7227)
    * Set PassengerRuby to ruby1.9.1 and install appropriate Passenger package
    * Keep Ruby alternative on 1.8 via alternatives module dependency (#7970)
* Add foreman::plugin::ovirt_provision class for ovirt_provision_plugin
* Install foreman-release-scl on EL clones (#7234)
* Refacter SSSD facts for faster runs
* Add docs to all classes/defines
* Remove expensive directory recursion on $vardir/yaml
* Deprecated: passenger_scl parameter has been replaced by passenger_ruby and
  passenger_ruby_package

## 2.2.4
* Set GPG keys for each Foreman repo
* Enable EPEL7 GPG checking (#6015)
* Wrap API parameters for new apipie-bindings
* Fix errors with strict variables
* Fix failed status calculation when log processor enabled

## 2.2.3
* Fix apipie-bindings cache path to prevent installer/master conflict
* Sync module configs

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
