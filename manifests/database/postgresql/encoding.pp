# @summary Class to ensure the packages for encoding are installed
# @api private
class foreman::database::postgresql::encoding {
  if $facts['os']['family'] == 'RedHat' {
    stdlib::ensure_packages(['glibc-langpack-en'])
  }
}
