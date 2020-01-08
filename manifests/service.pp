# @summary  Control earlyoom service
#
# @api private
#
class earlyoom::service (
  $service_enable = $earlyoom::service_enable,
) {

  assert_private()

  service{'earlyoom':
    ensure => $service_enable,
    enable => $service_enable,
  }
}
