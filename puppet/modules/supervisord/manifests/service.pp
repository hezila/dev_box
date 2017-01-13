# Class: supervisord::service
#
# Class for supervisord service
#
class supervisord::service inherits supervisord {
      if $::supervisord::service_manage {
         service { $::supervisord::service_name:
                 ensure => $::supervisord::service_ensure,
                 enable => $::supervisord::service_enable,
                 hasrestart => true,
                 hasstatus  => true,
                 restart    => $::supervisord::service_restart,
         }
      }
}