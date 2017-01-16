# Class: supervisord
#
# This class installs supervisord via pip
#
class supervisord(
      $package_ensure             = $supervisord::params::package_ensure,
      $package_name               = $supervisord::params::package_name,
      $package_provider           = $supervisord::params::package_provider,
      $package_install_options    = $supervisord::params::package_install_options,
      $service_manage             = $supervisord::params::service_manage,
      $service_ensure             = $supervisord::params::service_ensure,
      $service_enable             = $supervisord::params::service_enable,
      $service_name               = $supervisord::params::service_name,
      $service_restart            = $supervisord::params::service_restart,
      $install_init               = $supervisord::params::install_init,
      $init_type                  = $supervisord::params::init_type,
      $init_script                = $supervisord::params::init_script,
      $init_script_template       = $supervisord::params::init_script_template,
      $init_defaults              = $supervisord::params::init_defaults,
      $init_defaults_tempaltes    = $supervisord::params::init_defaults_templates,
      $executable                 = $supervisord::params::executable,
      $executable_ctl             = $supervisord::params::executable_ctl,

      $log_path                   = $supervisord::params::log_path,
      $log_file                   = $supervisord::params::log_file,
      $log_level                  = $supervisord::params::log_level,
      $logfile_maxbytes           = $supervisord::params::logfile_maxbytes,
      $logfile_backups            = $supervisord::params::logfile_backups,

      $run_path                   = $supervisord::params::run_path,
      $pid_file                   = $supervisord::params::pid_file,
      $nodaemon                   = $supervisord::params::nodaemon,
      $minfds                     = $supervisord::params::minfds,
      $minprocs                   = $supervisord::params::minprocs,
      $manage_config              = $supervisord::params::manage_config,
      $config_include             = $supervisord::params::config_include,
      $config_include_purge       = false,
      $config_file                = $supervisord::params::config_file,
      $config_file_mode           = $supervisord::params::config_file_mode,
      $config_dirs                = undef,
      $umask                      = $supervisord::params::umask,

      $ctl_socket                 = $supervisord::params::ctl_socket,

      $unix_socket                = $supervisord::params::unix_socket,
      $unix_socket_file           = $supervisord::params::unix_socket_file,
      $unix_socket_mode           = $supervisord::params::unix_socket_mode,
      $unix_socket_owner          = $supervisord::params::unix_socket_owner,
      $unix_socket_group          = $supervisord::params::unix_socket_group,
      $unix_auth                  = $supervisord::params::unix_auth,
      $unix_username              = $supervisord::params::unix_username,
      $unix_password              = $supervisord::params::unix_password,

      $inet_server                = $supervisord::params::inet_server,
      $inet_server_hostname       = $supervisord::params::inet_server_hostname,
      $inet_server_port           = $supervisord::params::inet_server_port,
      $inet_auth                  = $supervisord::params::inet_auth,
      $inet_username              = $supervisord::params::inet_username,
      $inet_password              = $supervisord::params::inet_password,

      $user                       = undef,
      $identifier                 = undef,
      $childlogdir                = undef,
      $directory                  = undef,
      $strip_ansi                 = false,
      $nocleanup                  = false,

      $groups                     = {},
      $programs                   = {}
) inherits supervisord::params {

  if $unix_socket and $inet_server {
     $use_ctl_socket  = $ctl_socket
  }
  elsif $unix_socket {
        $use_ctl_socket = 'unix'
  }
  elsif $inet_server {
        $use_ctl_socket = 'inet'
  }

  if $use_ctl_socket == 'unix' {
     $ctl_serverurl  = "unix://${supervisord::run_path}/${supervisord::unix_socket_file}"
     $ctl_auth       = $supervisord::unix_auth
     $ctl_username   = $supervisord::unix_username
     $ctl_password   = $supervisord::unix_password
  }
  elsif $use_ctl_socket == 'inet' {
        $ctl_serverurl  = "http://${supervisord::inet_server_host}/${supervisord::inet_server_port}"
        $ctl_auth       = $supervisord::inet_auth
        $ctl_username   = $supervisord::inet_username
        $ctl_password   = $supervisord::inet_password
  }

  if $config_dirs {
     $config_include_string = join($config_dirs, ' ')
  }
  else {
       $config_include_string   = "${config_include}/*.conf"
  }

  create_resources('supervisord::group', $groups)
  create_resources('supervisord::program', $programs)

  include supervisord::install
  include supervisord::config
  include supervisord::service
  include supervisord::reload

  anchor { 'supervisord::begin': }
  anchor { 'supervisord::end': }


  Anchor['supervisord::begin']
  -> Class['supervisord::install']
  -> Class['supervisord::config']
  -> Class['supervisord::service']
  -> Anchor['supervisord::end']

  /*
  Class['supervisord::service'] -> Supervisord::Program <| |>
  #Class['supervisord::service'] -> Supervisord::Fcgi_program <| |>
  #Class['supervisord::service'] -> Supervisord::Eventlistener <| |>
  Class['supervisord::service'] -> Supervisord::Group   <| |>
  #Class['supervisord::service'] -> Supervisord::Rpcinterface <| |>
  Class['supervisord::service'] -> Supervisord::Supervisorctl <| |>
  */
}
