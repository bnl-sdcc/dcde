#!/bin/bash
# 
# Simple install for globus-ssh client tool.
#
RHEL7=0
NONRHEL=0
INSTALL=0

if grep "Maipo\|Nitrogen\|CentOS Linux release 7" /etc/redhat-release ; then
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
		echo "Installing EPEL..."
		echo wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
		wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
		echo rpm -ivh epel-release-latest-7.noarch.rpm
		rpm -ivh epel-release-latest-7.noarch.rpm
		rm epel-release-latest-7.noarch.rpm

	    echo "yum -y install python2-pip"
		yum -y install python2-pip
		
		echo "pip install --upgrade pip"
		pip install --upgrade pip
		
		echo "pip install oauth-ssh"
		pip install oauth-ssh
	
		echo "Done."
	else
		echo "This script must be run as root..."
	
	fi
fi

if [ $NONRHEL -eq 1 ] ; then 
	echo "not implemented."

fi
