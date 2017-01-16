class xtrabackup::install {
      if $::lsbdistcodename != 'lucid' {
         package { 'percona-xtrabackup':
                 ensure => $xtrabackup::version
         }
      } else {
        package { 'percona-xtrabackup':
                ensure => $xtrabackup::version
        }
      }
}
