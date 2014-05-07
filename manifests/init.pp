#
class sshkeys {

  package { 'openssh-server':
	ensure => present,
  }

  file { '/etc/ssh/sshd_config':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0600',
    #content => template("ssh/sshd_config_${lsbdistcodename}.erb"),
    require => Package['openssh-server'],
  }
  
  file { '/root/.ssh':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0700',
  }
  
  file { '/root/.ssh/authorized_keys':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0600',
    source  => "puppet:///modules/sshkeys/root_authorized_keys",
    require => File['/root/.ssh'], 
  }
  
  service { 'ssh':
    ensure     => running,
    enable     => true,
    subscribe  => File['/etc/ssh/sshd_config'],
    require    => Package['openssh-server'],
  }
}

class ssh::password inherits ssh {
  File['/etc/ssh/sshd_config'] {
    content => template("ssh/sshd_config_password.erb"),
  }
}
