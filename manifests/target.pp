class nagios::target {
package { [ "nagios-nrpe-server", 
"nagios-plugins", 
"nagios-plugins-basic", 
"nagios-plugins-standard" ]: 
ensure => installed, 
} 

service { "nagios-nrpe-server": 
enable => true, 
ensure => running, 
pattern => "/usr/sbin/nrpe", 
require => Package["nagios-nrpe-server"], 
} 

file { "/etc/nagios/nrpe.cfg": 
source => "puppet:///modules/nagios/nrpe.cfg", 
require => Package["nagios-nrpe-server"], 
notify => Service["nagios-nrpe-server"], 
} 
}
