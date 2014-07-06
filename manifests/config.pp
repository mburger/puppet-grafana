#
# = Class: grafana::config
#
# This class manages grafana configurations
#
class grafana::config {

  if $grafana::file {
    file { 'grafana.conf':
      ensure  => $grafana::ensure,
      path    => $grafana::managed_file,
      mode    => $grafana::file_mode,
      owner   => $grafana::file_owner,
      group   => $grafana::file_group,
      source  => $grafana::file_source,
      content => $grafana::managed_file_content,
    }
  }

}
