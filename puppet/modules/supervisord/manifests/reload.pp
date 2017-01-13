# Class: supervisord::reload
#
# Class to reload and update supervisord with supervisorctl
#
class supervisord::reload inherits supervisord {
      if $::supervisord::service_name {
         $supervisorctl = $::supervisord::exectuable_ctl

         exec { 'supervisorctl_reload':
              command   => "${supervisorctl} reload"
              refreshonly  => true,
              require      => Service[$::supervisord::service_name],
         }
         exec { 'supervisorctl_update':
              command   => "${supervisorctl} update",
              refreshonly  => true,
              require      => Service[$::supervisord::service_name],
         }
      }
}