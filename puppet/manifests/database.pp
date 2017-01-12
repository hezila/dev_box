class database {
      exec { "apt-update-repo":
           command => "/usr/bin/sudo apt-get -y update"
      }

      package {
              ["mysql-client", "mysql-server", "libmysqlclient-dev", "redis-server"]:
              ensure => installed,
              require => Exec['apt-update']
      }

      service { "mysql":
              ensure => running,
              enable => true,
              require => Package["mysql-server"],
      }

      service { "redis-server":
              ensure => running,
              enable => true,
              require => Package["redis-server"],
      }
}