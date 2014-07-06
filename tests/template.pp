#
# Testing configuration file provisioning via template
# Auditing enabled
#
class { 'grafana':
  template => 'grafana/tests/test.conf',
  audit    => 'all',
}
