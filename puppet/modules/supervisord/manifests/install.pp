# Class supervisord::install
#
# Install supervisor package (defaults to use pip)
#
class supervisord::install inherits supervisord {
      package { $supervisord::package_name:
              ensure    => $supervisord::package_ensure,
              provider  => $supervisord::package_provider,
              install_options   => $supervisord::package_install_options,
      }
}