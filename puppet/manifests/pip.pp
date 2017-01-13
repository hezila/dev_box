class pip {
      Exec {
           path => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
      }

      ensure_packages('curl')

      exec { 'install_setuptools':
           command => "curl -kL ${setuptools_url} | python",
           cwd     => '/tmp'
           unless  => 'which easy_install',
           before  => Exec['install_pip'],
           require => Package['curl']
      }

      exec { 'install_pip':
           command  => 'easy_install pip'
           unless   => 'which pip'
      }
}