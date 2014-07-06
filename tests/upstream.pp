#
# Testing installation from upstream
#
class { 'grafana':
  install => 'upstream',
  version => '0.90.1',
}
