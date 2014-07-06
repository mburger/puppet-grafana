#
# = Class: grafana
#
# This class installs and manages grafana
#
#
# == Parameters
#
# [*elasticsearch_url*]
#   String. Default: http://"+window.location.hostname+":9200
#   Url of your elasticsearch server.
#   Example: http://es.${::domain}:9200
#
# [*virtualhost*]
#   String. Default: grafana.${::domain}
#   Name of the virtualhost for the grafana web interface
#   Set to undef to disable the creation of a virtualhost
#
# [*webserver*]
#   String. Default: apache
#   Name of the webserver that provides the grafana files.
#   Note that the relevant $webserver class is included
#   Set to undef to disable the inclusion of the $webserver module.
#
# Refer to the official documentation for standard parameters usage.
# Look at the code for the list of supported parametes and their defaults.
#
class grafana (

  $elasticsearch_url   = 'http://"+window.location.hostname+":9200',
  $virtualhost         = "grafana.${::domain}",
  $webserver           = undef,

  $ensure              = 'present',
  $version             = '1.6.1',

  $install             = 'upstream',
  $install_base_url    = 'http://grafanarel.s3.amazonaws.com',
  $install_url         = undef,
  $install_destination = '/opt',
  $install_exec_env    = [],

  $package_name        = 'grafana',

  $file                = '/etc/grafana/config.js',
  $file_source         = undef,
  $file_template       = undef,
  $file_content        = undef,
  $file_options_hash   = undef,
  $file_mode           = '0664',
  $file_owner          = 'root',
  $file_group          = 'root',

  $dependency_class    = 'grafana::dependency',
  $my_class            = undef,

  ) {


  # Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent all the resources managed by the module are removed.')
  validate_re($install, ['package','upstream','puppi'], 'Valid values are: package, upstream, puppi.')
  if $file_options_hash { validate_hash($file_options_hash) }

  # Calculation of variables used in the module
  if $file_content {
    $managed_file_content = $file_content
  } else {
    if $file_template {
      $managed_file_content = template($file_template)
    } else {
      $managed_file_content = undef
    }
  }

  $managed_package_ensure = $version ? {
    'master' => $ensure,
    undef    => $ensure,
    default  => $version,
  }

  if $grafana::install_url {
    $managed_install_url = $grafana::install_url
    $download_file_name = url_parse($grafana::install_url,'filename')
    $extracted_dir = url_parse($download_file_name, 'filedir')
  } else {
    $managed_install_url = "${grafana::install_base_url}/grafana-${grafana::version}.zip"
    $download_file_name = "grafana-${grafana::version}.zip"
    $extracted_dir = "grafana-${grafana::version}"
  }

  $home_dir = "${grafana::install_destination}/${grafana::extracted_dir}"

  $managed_file = $grafana::install ? {
    package => $grafana::file,
    default => "${grafana::home_dir}/config.js",
  }

  # Resources Managed
  class { 'grafana::install':
  }

  class { 'grafana::config':
    require => Class['grafana::install'],
  }


  # Extra classes
  if $grafana::dependency_class {
    include $grafana::dependency_class
  }

  if $grafana::my_class {
    include $grafana::my_class
  }

}
