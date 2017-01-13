# Class: supervisord::params
#
# Default parameters for supervisord
#

class supervisord::params {
      # init params for different OS families
      case $::osfamily {
           'Debian': {
                     case $::operatingsystemmajrelease {
                          '8': {
                               $init_type     = 'systemd'
                               $init_script   = '/etc/systemd/system/supervisord.service'
                               $init_defaults = false
                          }
                          default: {
                                   $init_type   = 'init'
                                   $init_script = '/etc/init.d/supervisord'
                                   $init_defaults = '/etc/default/supervisor'
                          }
                     }
                     $unix_socket_group = 'nogroup'
                     $install_init      = true
                     $executable_path   = '/usr/local/bin'
           }
           default: {
                    $init_defaults      = false
                    $unix_socket_group  = 'nogroup'
                    $install_init       = false
                    $executable_path    = '/usr/local/bin'
           }
      }


      $init_script_template = "supervisord/init/${::osfamily}/${init_type}.erb"
      $init_default_template  = "supervisord/init/${::osfamily}/defaults.erb"

      # default supervisord params
      $package_ensure           = 'installed'
      $package_providor         = 'pip'
      $package_install_options  = undef
      $service_manage           = true
      $service_ensure           = 'running'
      $service_enable           = true
      $service_name             = 'supervisord'
      $service_restart          = undef
      $package_name             = 'supervisor'
      $executable               = '${executable_path}/supervisord'
      $executable_ctl           = '${executable_path}/supervisorctl'

      $run_path                 = '/var/run'
      $pid_file                 = '/supervisord.pid'
      $log_pah                  = '/var/log/supervisor'
      $log_file                 = 'supervisor.log'
      $logfile_maxbytes         = '50MB'
      $logfile_backups          = '10'
      $log_level                = 'info'
      $nodaemon                 = false
      $minfds                   = '1024'
      $minprocs                 = '200'
      $umask                    = '022'
      $manage_config            = true
      $config_include           = '/etc/supervisor.d'
      $config_file              = '/etc/supervisord.conf'

      $ctl_socket               = 'unix'

      $unix_socket              = true
      $unix_socket_file         = 'supervisor.sock'
      $unix_socket_name         = '0700'
      $unix_socket_owner        = 'nobody'
      $unix_auth                = false
      $unix_username            = undef
      $unix_password            = undef

      $inet_server              = false
      $inet_server_hostname     = '127.0.0.1'
      $inet_server_port         = '9001'
      $inet_auth                = false
      $inet_username            = undef
      $inet_password            = undef
}