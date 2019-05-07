#!/bin/bash
#
# Installs globus-sshd server on RHEL7
# John Hover <jhover@bnl.gov>
#

RHEL7=0
NONRHEL=0
INSTALL=0

if grep "Maipo\|Nitrogen" /etc/redhat-release ; then
    echo "RHEL/SL/Centos 7"
	RHEL7=1    
fi

if [ `whoami` = "root" ]; then
	INSTALL="root"
else
	INSTALL="user"
fi


if [ $RHEL7 -eq 1 ] ; then
	echo "redhat 7"
	if [ "$INSTALL" = "root" ] ; then
		echo "Ensure ssh server..."
		yum -y install openssh-server

		yum -y install https://dev.racf.bnl.gov/dist/dcde/rpms/rhel7/globus-sshd-config-0.90-1.noarch.rpm
		
		yum -y install https://dev.racf.bnl.gov/dist/dcde/rpms/rhel7/oauth-ssh-0.9-1.el7.x86_64.rpm

		systemctl enable globus-sshd.service
		
		cd /usr/sbin ; wget 

		cd /etc/cron.d ; wget https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/fetchdcdefiles.cron
		

	else
		echo "This script must be run as root..."
	
	fi
fi

if [ $NONRHEL -eq 1 ] ; then 
	echo "not implemented."

fi