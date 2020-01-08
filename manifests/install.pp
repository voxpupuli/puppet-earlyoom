# @summary Installs earlyoom
#
# @api private
#
class earlyoom::install (
  $pkgname        = $earlyoom::pkgname,
) {

  assert_private()

  package{$pkgname:
    ensure => 'present',
  }

}
