#!/bin/bash
#
# Simple grid client setup.
# Currently only works for root/systemwide setup.  
#
# Installs grid-proxy-init and gsissh 
# Installs CA certs needed for those programs. 
# John Hover <jhover@bnl.gov>
#
# TODO: Install as user (with progs and CAs in home dir). 
# TODO: Install on Mac (as root or user). 

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
		echo "Installing EPEL..."
		echo wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
		wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
		echo rpm -ivh epel-release-latest-7.noarch.rpm
		rpm -ivh epel-release-latest-7.noarch.rpm
		rm epel-release-latest-7.noarch.rpm
		
		echo "Installing gsi clients..."
		echo yum -y install gsi-openssh-clients fetch-crl
		yum -y install gsi-openssh-clients fetch-crl
	
		echo "Installing OSG CI certs..."
		echo wget https://repo.opensciencegrid.org/osg/3.4/el7/release/x86_64/osg-ca-certs-1.78-1.osg34.el7.noarch.rpm
		wget https://repo.opensciencegrid.org/osg/3.4/el7/release/x86_64/osg-ca-certs-1.78-1.osg34.el7.noarch.rpm
		echo rpm -ivh osg-ca-certs-1.78-1.osg34.el7.noarch.rpm
		rpm -ivh osg-ca-certs-1.78-1.osg34.el7.noarch.rpm
		rm osg-ca-certs-1.78-1.osg34.el7.noarch.rpm
	
	
	
		echo "Installing ANL Entrust CA certs..."
		cd /etc/grid-security/certificates/
		echo wget https://dev.racf.bnl.gov/dist/jhover/anl-entrust.tgz
		wget https://dev.racf.bnl.gov/dist/jhover/anl-entrust.tgz
		echo tar -xvzf anl-entrust.tgz
		tar -xvzf anl-entrust.tgz
		rm anl-entrust.tgz
		cd -
		
		echo "Running fetch-crl. This often takes several (~6) minutes..."
		echo "fetch-crl"
		fetch-crl
	else
		echo "This script must be run as root..."
	
	fi
fi

if [ $NONRHEL -eq 1 ] ; then 
	echo "not implemented."

fi



