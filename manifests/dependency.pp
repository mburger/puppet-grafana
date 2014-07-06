# Class: grafana::dependency
#
# This class installs grafana dependency
#
# == Usage
#
# This class may contain resources available on the
# Example42 modules set.
#
class grafana::dependency {

  if $grafana::webserver {
    include $grafana::webserver
  }

  if $grafana::webserver == 'apache'
  and $grafana::virtualhost {
    apache::vhost { $grafana::virtualhost:
      docroot  => $grafana::home_dir,
    }
  }

}
