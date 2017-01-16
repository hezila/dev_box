#definition: supervisord::group
#
# === Examples
#
# supervisord::group { 'Group of Tornado Apps running on multiple ports':
#   group_name      => 'tornado_app_servers',
#   names           => 'tornado_app_10001,tornado_app_10002,tornado_app_10003',
# }
#
# Document on parameters available at:
# http://supervisord.org/configuration.html#group-x-section-settings

define supervisord::group (
  $programs,
  $ensure   = present,
  $priority = undef,
  $config_file_mode = '0644'
) {

  include supervisord

  $progstring = array2csv($programs)
  $conf       = "${supervisord::config_include}/group_${name}.conf"

  file { $conf:
    ensure  => $ensure,
    content => template('supervisord/conf/group.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => $config_file_mode,
    notify  => Class['supervisord::reload']
  }
}
