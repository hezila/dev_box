import "archive.pp"
import "database.pp"
import "golang.pp"

class core {
      exec { "apt-update":
           command => "/usr/bin/sudo apt-get -y update"
      }

      package {
              [ "vim", "git-core", "build-essential", "libssl-dev", "libffi-dev" ]:
                ensure => ["installed"],
                require => Exec['apt-update']
      }
}

class python {
      package {
              [ "python", "python-setuptools", "python-dev", "python-pip" ]:
                ensure => ["installed"],
                require => Exec['apt-update']
      }

      exec {
           "virtualenv":
           command => "/usr/bin/sudo pip install virtualenv",
           require => Package["python-dev", "python-pip"],
      }
}

class web {
      package {
              [ "python-twisted" ]:
                ensure => ["installed"],
                require => Exec['apt-update']
      }

      exec {
           "sqlalchemy":
           command => "/usr/bin/sudo pip install sqlalchemy",
           require => Package["python-pip"],
      }
}

class flask {
      exec {
           "fabric":
            command => "/usr/bin/sudo pip install fabric",
            require => Package["python-pip"]
      }

      exec {
           "Flask":
           command => "/usr/bin/sudo pip install Flask",
           require => Package["python-pip"]
      }
}

class { 'golang':
  version => '1.7',
  user => 'vagrant',
  gopath => '/vagrant/workspace/golang',
  installdir => '/home/vagrant/opt',
}

include core
include python
include web
include flask
include database