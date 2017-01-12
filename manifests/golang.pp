class golang(
      $installdir = "/usr/local",
      $version    = "1.7",
      $user       = "root",
      $gopath     = "/root/go"
 ) {
   if $user == 'root' {
      $profiledir = '/etc/profile'
   } else {
     $profiledir = "/home/${user}"
   }

   file { "golang-dir":
        path => $installdir,
        ensure => "directory",
        owner => $user
   }

   file { "golang-gopath":
        path => $gopath,
        ensure => "directory",
        owner => $user
   }

   archive {"go${version}":
           ensure => present,
           url => "https://storage.googleapis.com/golang/go${version}.linux-amd64.tar.gz",
           target => "${installdir}",
   }

   # Enviroment variables
   exec { "goroot-profile":
        command => "echo 'export GOROOT=${installdir}/go' >> ${profiledir}/.profile",
        path => [ '/usr/bin', '/bin' ],
        unless => "grep 'GOROOT' ${profiledir}/.profile",
   }

   exec { "gowkspc-profile":
        command => "echo 'export GOPATH=${gopath}' >> ${profiledir}/.profile",
        path => [ '/usr/bin', '/bin' ],
        unless => "grep 'GOPATH' ${profiledir}/.profile"
   }

   exec { "gopath-profile":
        command => "echo 'export PATH=\$PATH:${installdir}/go/bin' >> ${profiledir}/.profile",
        path => [ '/usr/bin', '/bin' ],
        unless => "grep '${installdir}/go/bin' ${profiledir}/.profile"
   }
 }