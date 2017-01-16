# Class: xtrabackup
#
# Configures xtrabackup to take MySQL database backups
#
class xtrabackup (
      $workdir      = '/tmp', # working directory, which already exist. (Optional, uses /tmp by default)
      $outputdir    = undef, # directory to write backups to
      $parallel     = 1, # speed up backup by using many threads
      $slaveinfo    = undef, # record master info so that a slave can be created from this backup
      $scriptdir    = '/usr/local/bin/', # specify the actual directory to put the script on the filesystem
      $p_threads    = 10, # speed up pigz by using addtional threads
      $version      = 'present'
) {
  class{'xtrabackup::install': } ->
  class{'xtrabackup::config': }  ->
  Class['xtrabackup']
}