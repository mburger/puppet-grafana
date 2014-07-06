#
# = Class: grafana::install
#
# This class installs grafana
#
class grafana::install {

  case $grafana::install {

    package: {

      if $grafana::package_name {
        package { $grafana::package_name:
          ensure   => $grafana::managed_package_ensure,
          provider => $grafana::package_provider,
        }
      }
    }

    upstream: {

      puppi::netinstall { 'netinstall_grafana':
        url                 => $grafana::managed_install_url,
        destination_dir     => $grafana::install_destination,
        extracted_dir       => $grafana::extracted_dir,
        exec_env            => $grafana::install_exec_env,
        retrieve_command    => "wget -O ${grafana::download_file_name}",
      }

      file { 'grafana_link':
        ensure => "${grafana::home_dir}" ,
        path   => "${grafana::install_destination}/grafana",
      }
    }

    puppi: {

      puppi::project::archive { 'grafana':
        source      => $grafana::managed_install_url,
        deploy_root => $grafana::install_destination,
        auto_deploy => true,
        enable      => true,
      }

      file { 'grafana_link':
        ensure => "${grafana::home_dir}" ,
        path   => "${grafana::install_destination}/grafana",
      }
    }

    default: { }

  }

}
