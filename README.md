# Puppet module: grafana

This is a Puppet module for Kibana3: http://three.grafana.org/ .

It manages its installation and configuration.

The module is based on stdmod naming standars.
Refer to http://github.com/stdmod/

Released under the terms of Apache 2 License.

NOTE: This module is to be considered a POC, that uses the stdmod naming conventions.
For development time reasons the module currently uses some Example42 modules and prerequisites.


## USAGE - Common parameters

* Installation of grafana with common configuration parameters

        class { 'grafana':
          elasticsearch_url => "http://elastic.${::domain}:9200",
          webserver         => 'apache',
          virtualhost       => 'logs.example42.com', # Default: grafana.${::domain}
          file_template     => 'example42/grafana/config.js',
        }


## USAGE - Basic management

* Install grafana fetching the upstream master.zip.
  Note: By default grafana is installed but no webserver is configured to serve its files.

        class { 'grafana': }

* Install grafana and setup apache to serve it with a custom virtualhost

        class { 'grafana':
          webserver   => 'apache',
          virtualhost => 'logs.example42.com', # Default: grafana.${::domain}
        }

* Install grafana from a custom url to a custom destination

        class { 'grafana':
          install_url         => 'http://files.example42.com/grafana/3.1.zip',
          install_destination => '/var/www/html', # Default: /opt
        }

* Define the url of your elastisearch server

        class { 'grafana':
          elasticsearch_url => "http://elastic.${::domain}:9200",
        }

* Install grafana fetching a specific version

        class { 'grafana':
          install => 'upstream',
          version => '3.0.1',
        }

* Install grafana via OS package

        class { 'grafana':
          install => 'package',
        }

* Remove grafana package and purge all the managed files

        class { 'grafana':
          ensure => absent,
        }

* Enable auditing (on all the arguments)

        class { 'grafana':
          audit => 'all',
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'grafana':
          noop => true,
        }


## USAGE - Overrides and Customizations
* Use custom source for main configuration file

        class { 'grafana':
          file_source => [ "puppet:///modules/example42/grafana/grafana.conf-${hostname}" ,
                           "puppet:///modules/example42/grafana/grafana.conf" ],
        }


* Use custom template for main config file. Note that template and source arguments are alternative.

        class { 'grafana':
          file_template => 'example42/grafana/grafana.conf.erb',
        }

* Use a custom template and provide an hash of custom configurations that you can use inside the template

        class { 'grafana':
          file_template       => 'example42/grafana/grafana.conf.erb',
          file_options_hash  => {
            opt  => 'value',
            opt2 => 'value2',
          },
        }


* Specify the name of a custom class to include that provides the dependencies required by the module

        class { 'grafana':
          dependency_class => 'site::grafana_dependency',
        }


* Automatically include a custom class with extra resources related to grafana.
  Here is loaded $modulepath/example42/manifests/my_grafana.pp.
  Note: Use a subclass name different than grafana to avoid order loading issues.

        class { 'grafana':
          my_class => 'site::my_grafana',
        }


## TESTING
[![Build Status](https://api.travis-ci.org/example42/puppet-grafana.png?branch=master)](https://travis-ci.org/example42/puppet-grafana)
