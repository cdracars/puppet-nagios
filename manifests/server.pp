class nagios::server { 

include apache 

package { [ "nagios3", 
"nagios-images", 
"nagios-nrpe-plugin" ]: 
ensure => installed, 
}

service { "nagios3": 
ensure => running, 
enable => true, 
require => Package["nagios3"], 
}
 
exec { "nagios-config-check": 
command => "/usr/sbin/nagios3 -v /etc/nagios3/nagios.cfg && /usr/sbin/service nagios3 restart", 
refreshonly => true, 
}
 
file { "/etc/apache2/sites-available/nagios.conf": 
source => "puppet:///modules/nagios/nagios.conf", 
notify => Service["apache2"], 
require => Package["apache2"], 
}
 
file { "/etc/apache2/sites-enabled/nagios.conf": 
ensure => symlink, 
target => "/etc/apache2/sites-available/nagios.conf", 
require => Package["apache2"], 
} 

file { [ "/etc/nagios3/generic-service_nagios2.cfg", 
"/etc/nagios3/services_nagios2.cfg", 
"/etc/nagios3/hostgroups_nagios2.cfg", 
"/etc/nagios3/extinfo_nagios2.cfg", 
"/etc/nagios3/localhost_nagios2.cfg", 
"/etc/nagios3/contacts_nagios2.cfg", 
"/etc/nagios3/conf.d" ]: 
ensure => absent,
force => true, 
} 

define nagios-config() {
file { "/etc/nagios3/${name}": 
source => "/tmp/vagrant-puppet/modules-0/nagios/files/${name}", 
require => Package["nagios3"], 
notify => Exec["nagios-config-check"], 
}
}

#Nagios monitoring serverNagios monitoring serverdeploying, steps
nagios-config { [ "htpasswd.nagios", 
"nagios.cfg", 
"cgi.cfg", 
"hostgroups.cfg", 
"hosts.cfg", 
"host_templates.cfg", 
"service_templates.cfg", 
"services.cfg", 
"timeperiods.cfg", 
"contacts.cfg", 
"commands.cfg" ]: 
}
 
file { "/var/lib/nagios3": # see http://bugs.debian.org/cgi- bin/bugreport.cgi?bug=478889 
mode => 751, 
require => Package["nagios3"], 
notify => Service["nagios3"],
}

file { "/var/lib/nagios3/rw": # see http://bugs.debian.org/ cgi-bin/bugreport.cgi?bug=478889 
mode => 2710, 
require => Package["nagios3"], 
notify => Service["nagios3"], 
} 
}
