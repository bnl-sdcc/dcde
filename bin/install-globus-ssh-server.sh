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
		echo "yum -y install openssh-server"
		yum -y install openssh-server
		
		echo "Install oauth-ssh PAM RPM..."		
		echo "yum -y install https://dev.racf.bnl.gov/dist/dcde/rpms/rhel7/oauth-ssh-0.9-1.el7.x86_64.rpm"		
		yum -y install https://dev.racf.bnl.gov/dist/dcde/rpms/rhel7/oauth-ssh-0.9-1.el7.x86_64.rpm

		echo "Install globus-ssh configuration RPM..."
		echo "yum -y install https://dev.racf.bnl.gov/dist/dcde/rpms/rhel7/globus-sshd-config-0.90-1.noarch.rpm"
		yum -y install https://dev.racf.bnl.gov/dist/dcde/rpms/rhel7/globus-sshd-config-0.90-1.noarch.rpm

		echo "Setup globus-acct-map fetch script and cron file..."

		echo "cd /usr/sbin ; wget https://raw.githubusercontent.com/bnl-sdcc/dcde/master/bin/fetchdcdefiles.sh -O fetchdcdefiles.sh ; chmod +x fetchdcdefiles.sh"
		cd /usr/sbin ; wget https://raw.githubusercontent.com/bnl-sdcc/dcde/master/bin/fetchdcdefiles.sh -O fetchdcdefiles.sh ; chmod +x fetchdcdefiles.sh

		echo "cd /etc/cron.d ; wget https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/fetchdcdefiles.cron -O fetchdcdefiles.cron"
		cd /etc/cron.d ; wget https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/fetchdcdefiles.cron -O fetchdcdefiles.cron
		
		echo "Enable service.."
		echo "systemctl enable globus-sshd.service"
		systemctl enable globus-sshd.service
	
		echo "Run fetch script..."
		echo "/usr/sbin/fetchdcdefiles.sh"
		/usr/sbin/fetchdcdefiles.sh

		echo "You must now register your instance with globus:  https://auth.globus.org/v2/web/developers  "
		echo "client_id and client_secret values MUST be set in /etc/oauth_ssh/globus-ssh.conf"
		echo "Afterwards, to start service run 'systemctl start globus-sshd.service' "
		echo "Done"
		
	else
		echo "This script must be run as root..."
	
	fi
fi

if [ $NONRHEL -eq 1 ] ; then 
	echo "not implemented."

fi