#
# Testing configuration file provisioning via source
# Auditing enabled
#
class { 'grafana':
  source => 'puppet:///modules/grafana/tests/test.conf',
  audit  => 'all',
}
