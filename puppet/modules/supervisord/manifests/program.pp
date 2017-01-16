#definition: supervisord::program
#
# === Examples
#
# supervisord::program { 'node_app':
#   command   => '/usr/bin/node server.js',
#   user      => 'node-user',
#   directory => '/var/www/node.foo.bar/'
# }
#
# Document on parameters available at:
# http://supervisord.org/configuration.html#program-x-section-settings
#

define supervisord::program (
  $command,
  $ensure                   = present,
  $ensure_process           = 'running',
  $process_name             = "program_${name}",
  $numprocs                 = undef,
  $numprocs_start           = undef,
  $priority                 = undef,
  $autostart                = undef,
  $autorestart              = undef,
  $startsecs                = undef,
  $startretries             = undef,
  $exitcodes                = undef,
  $stopsignal               = undef,
  $stopwaitsecs             = undef,
  $stopasgroup              = undef,
  $killasgroup              = undef,
  $user                     = undef,
  $redirect_stderr          = undef,
  $stdout_logfile           = "program_${name}.log",
  $stdout_logfile_maxbytes  = '50MB',
  $stdout_logfile_backups   = '10',
  $stdout_capture_maxbytes  = '0',
  $stdout_events_enabled    = undef,
  $stderr_logfile           = 'program_${name}.error',
  $stderr_logfile_maxbytes  = '50MB',
  $stderr_logfile_backups   = '10',
  $stderr_capture_maxbytes  = '0',
  $stderr_events_enabled    = undef,
  $environment              = undef,
  $directory                = undef,
  $umask                    = undef,
  $serverurl                = undef,
  $config_file_mode         = '0644'
) {
  include supervisord

  # create log variable
  $stdout_logfile_path = $stdout_logfile ? {
                       /(NONE|AUTO|syslog)/ => $stdout_logfile,
                       /^\//                => $stdout_logfile,
                       default              => "${supervisord::log_path}/${stdout_logfile}",
  }

  $stderr_logfile_path = $stderr_logfile ? {
                       /(NONE|AUTO|syslog)/ => $stderr_logfile,
                       /^\//                => $stderr_logfile,
                       default              => "${supervisord::log_path}/${stderr_logfile}",
  }

  # handle deprecated $environment variable
  if $environment { notify {'[supervisord] *** DEPRECATED WARNING ***: $program_environment has replaced $environment':}}
  $_program_environment = $program_environment ? {
                        undef                  => $environment,
                        default                => $program_environment
  }


  file { "$conf":
    ensure  => $ensure,
    content => template('supervisord/program.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => $config_file_mode,
    content => template('supervisord/conf/program.erb'),
    notify  => Class['supervisord::reload'],
  }

  case $ensure_process {
       'stopped': {
                  supervisord::supervisorctl { "stop_${name}":
                      command => 'stop',
                      process => $name
                  }
       }
       'removed': {
                  supervisord::supervisorctl { "remove_${name}":
                      command => 'remove',
                      process => $name
                  }
       }
       'running': {
                  supervisord::supervisorctsl { "start_${name}":
                      command => 'start',
                      process => $name,
                      unless  => running
                  }
       }
       default: {}
  }
}
